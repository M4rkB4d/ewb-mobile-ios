//
//  User.swift
//  EWBMobile
//
//  Created by Mark Paul Ramirez on 1/17/26.
//

import Foundation

// MARK: - User

struct User: Codable, Identifiable {
    let id: String
    let email: String
    let firstName: String
    let lastName: String
    let phone: String?
    let balance: Double?
    
    // Computed properties
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    var accountNumber: String {
        "1234-5678-9012"
    }
    
    var accountBalance: Double {
        balance ?? 10000.00
    }
}

// MARK: - Login Request

struct LoginRequest: Codable {
    let email: String
    let password: String
}

// MARK: - Login Response (no longer needed, using AuthResponse in AuthService)

// MARK: - API Response

struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let message: String?
    let data: T?
}
