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
    let name: String
    
    // Mock data for POC
    var accountNumber: String {
        "1234-5678-9012"
    }
    
    var accountBalance: Double {
        50000.00
    }
}

// MARK: - Login Request

struct LoginRequest: Codable {
    let email: String
    let password: String
}

// MARK: - Login Response

struct LoginResponse: Codable {
    let token: String
    let user: User
}

// MARK: - API Response

struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let message: String?
    let data: T?
}
