//
//  Constants.swift
//  EWBMobile
//
//  Created by Mark Paul Ramirez on 1/17/26.
//

import Foundation

struct Constants {
    
    // MARK: - API Configuration
    struct API {
        #if DEBUG
        static let baseURL = "http://localhost:8080/api"
        #else
        static let baseURL = "https://your-production-url.com/api"
        #endif
        
        // Auth API (centralized authentication)
        static let auth = "/auth"
        
        // Bills Payment API
        static let billsPayment = "/bills-payment/v1"
        
        // Fund Transfer API (future)
        static let fundTransfer = "/fund-transfer/v1"
        
        // Buy Load API (future)
        static let buyLoad = "/buy-load/v1"
    }
    
    // MARK: - Web Module URLs
    struct WebModules {
        #if DEBUG
        // Development URLs (React dev servers)
        static let billsPayment = "http://localhost:3000"
        static let fundTransfer = "http://localhost:3001"
        static let buyLoad = "http://localhost:3002"
        #else
        // Production URLs
        static let billsPayment = "https://bills.ewb-mobile.com"
        static let fundTransfer = "https://transfer.ewb-mobile.com"
        static let buyLoad = "https://load.ewb-mobile.com"
        #endif
    }
    
    // MARK: - Storage Keys
    struct Storage {
        static let authToken = "auth_token"
        static let refreshToken = "refresh_token"
        static let currentUser = "current_user"
    }
    
    // MARK: - App Info
    struct App {
        static let name = "EWB Mobile"
        static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
}
