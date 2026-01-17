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
        guard let url = URL(string: Constants.API.baseURL + Constants.API.billsPayment + "/auth/login") else {
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
            if let errorResponse = try? JSONDecoder().decode(APIResponse<LoginResponse>.self, from: data) {
                throw APIError.serverError(errorResponse.message ?? "Login failed")
            }
            throw APIError.serverError("Login failed")
        }
        
        let apiResponse = try JSONDecoder().decode(APIResponse<LoginResponse>.self, from: data)
        
        guard let loginData = apiResponse.data else {
            throw APIError.serverError(apiResponse.message ?? "Login failed")
        }
        
        // Store credentials
        UserDefaults.standard.set(loginData.token, forKey: Constants.Storage.authToken)
        if let userData = try? JSONEncoder().encode(loginData.user) {
            UserDefaults.standard.set(userData, forKey: Constants.Storage.currentUser)
        }
        
        // Update state on main thread
        await MainActor.run {
            self.currentUser = loginData.user
            self.authToken = loginData.token
            self.isAuthenticated = true
        }
        
        return loginData.user
    }
    
    // MARK: - Logout
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: Constants.Storage.authToken)
        UserDefaults.standard.removeObject(forKey: Constants.Storage.currentUser)
        
        self.currentUser = nil
        self.authToken = nil
        self.isAuthenticated = false
    }
}
