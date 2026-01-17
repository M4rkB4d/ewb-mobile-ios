//
//  AuthViewModel.swift
//  EWBMobile
//
//  Created by Mark Paul Ramirez on 1/17/26.
//

import Foundation
import SwiftUI
import Combine

// MARK: - Auth ViewModel

@MainActor
class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let authService = AuthService.shared
    
    var isAuthenticated: Bool {
        authService.isAuthenticated
    }
    
    var currentUser: User? {
        authService.currentUser
    }
    
    // MARK: - Login
    
    func login() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter email and password"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await authService.login(email: email, password: password)
            // Clear form
            email = ""
            password = ""
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // MARK: - Logout
    
    func logout() {
        authService.logout()
    }
}
