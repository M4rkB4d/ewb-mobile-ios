//
//  PrimaryButton.swift
//  EWBMobile
//
//  Created by Mark Paul Ramirez on 1/17/26.
//

import SwiftUI

// MARK: - Primary Button

struct PrimaryButton: View {
    let title: String
    var isLoading: Bool = false
    var isDisabled: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                }
                Text(isLoading ? "Please wait..." : title)
                    .font(.headline)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(isDisabled ? Color.gray : Color.ewbBlue)
            .cornerRadius(12)
        }
        .disabled(isDisabled || isLoading)
    }
}

// MARK: - Secondary Button

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.ewbBlue)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.ewbBlue.opacity(0.1))
                .cornerRadius(12)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        PrimaryButton(title: "Continue", action: {})
        PrimaryButton(title: "Loading", isLoading: true, action: {})
        PrimaryButton(title: "Disabled", isDisabled: true, action: {})
        SecondaryButton(title: "Cancel", action: {})
    }
    .padding()
}
