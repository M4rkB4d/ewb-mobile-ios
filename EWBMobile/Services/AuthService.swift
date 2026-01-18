//
//  AuthService.swift
//  EWBMobile
//
//  Created by Mark Paul Ramirez on 1/17/26.
//

import Foundation
import Combine

// MARK: - API Error

enum APIError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case unauthorized
    case serverError(String)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to process response"
        case .unauthorized:
            return "Please login again"
        case .serverError(let message):
            return message
        case .networkError(let error):
            return error.localizedDescription
        }
    }
}

// MARK: - Auth Response (new structure from auth-api)

struct AuthResponse: Codable {
    let success: Bool
    let message: String?
    let token: String?
    let refreshToken: String?
    let user: User?
}

// MARK: - Auth Service

class AuthService: ObservableObject {
    static let shared = AuthService()
    
    @Published var currentUser: User?
    @Published var isAuthenticated: Bool = false
    @Published var authToken: String?
    
    private init() {
        loadStoredUser()
    }
    
    // MARK: - Load Stored User
    
    private func loadStoredUser() {
        if let userData = UserDefaults.standard.data(forKey: Constants.Storage.currentUser),
           let user = try? JSONDecoder().decode(User.self, from: userData),
           let token = UserDefaults.standard.string(forKey: Constants.Storage.authToken) {
            self.currentUser = user
            self.authToken = token
            self.isAuthenticated = true
        }
    }
    
    // MARK: - Login
    
    func login(email: String, password: String) async throws -> User {
        // Use centralized auth API
        guard let url = URL(string: Constants.API.baseURL + Constants.API.auth + "/login") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginRequest = LoginRequest(email: email, password: password)
        request.httpBody = try JSONEncoder().encode(loginRequest)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.noData
        }
        
        guard httpResponse.statusCode == 200 else {
            if let errorResponse = try? JSONDecoder().decode(AuthResponse.self, from: data) {
                throw APIError.serverError(errorResponse.message ?? "Login failed")
            }
            throw APIError.serverError("Login failed")
        }
        
        let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
        
        guard let token = authResponse.token,
              let user = authResponse.user else {
            throw APIError.serverError(authResponse.message ?? "Login failed")
        }
        
        // Store credentials
        UserDefaults.standard.set(token, forKey: Constants.Storage.authToken)
        if let refreshToken = authResponse.refreshToken {
            UserDefaults.standard.set(refreshToken, forKey: Constants.Storage.refreshToken)
        }
        if let userData = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(userData, forKey: Constants.Storage.currentUser)
        }
        
        // Seed demo bills for new user
        await seedDemoBills(token: token)
        
        // Update state on main thread
        await MainActor.run {
            self.currentUser = user
            self.authToken = token
            self.isAuthenticated = true
        }
        
        return user
    }
    
    // MARK: - Seed Demo Bills
    
    private func seedDemoBills(token: String) async {
        guard let url = URL(string: Constants.API.baseURL + Constants.API.billsPayment + "/bills/seed-demo") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = "{}".data(using: .utf8)
        
        do {
            let _ = try await URLSession.shared.data(for: request)
        } catch {
            // Ignore seed errors - bills may already exist
            print("Bills seed skipped: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Logout
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: Constants.Storage.authToken)
        UserDefaults.standard.removeObject(forKey: Constants.Storage.refreshToken)
        UserDefaults.standard.removeObject(forKey: Constants.Storage.currentUser)
        
        self.currentUser = nil
        self.authToken = nil
        self.isAuthenticated = false
    }
}
