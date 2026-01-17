//
//  Extensions.swift
//  EWBMobile
//
//  Created by Mark Paul Ramirez on 1/17/26.
//

import Foundation
import SwiftUI

// MARK: - Double Extensions

extension Double {
    var asCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "PHP"
        formatter.currencySymbol = "₱"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? "₱0.00"
    }
}

// MARK: - Date Extensions

extension Date {
    var formatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
    
    var formattedWithTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}

// MARK: - View Extensions

extension View {
    func cardStyle() -> some View {
        self
            .background(.background)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

// MARK: - Color Extensions

extension Color {
    static let ewbBlue = Color(red: 0/255, green: 51/255, blue: 160/255)      // EWB Brand Blue
    static let ewbGold = Color(red: 198/255, green: 156/255, blue: 109/255)   // EWB Gold
    static let successGreen = Color(red: 34/255, green: 197/255, blue: 94/255)
    static let warningYellow = Color(red: 234/255, green: 179/255, blue: 8/255)
    static let errorRed = Color(red: 239/255, green: 68/255, blue: 68/255)
}
