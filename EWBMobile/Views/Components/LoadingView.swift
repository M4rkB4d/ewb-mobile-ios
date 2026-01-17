//
//  LoadingView.swift
//  EWBMobile
//
//  Created by Mark Paul Ramirez on 1/17/26.
//

import SwiftUI

// MARK: - Loading View

struct LoadingView: View {
    var message: String = "Loading..."
    
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(.ewbBlue)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Loading Overlay

struct LoadingOverlay: View {
    var message: String = "Processing..."
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.2)
                    .tint(.white)
                
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            .padding(32)
            .background(Color(.systemGray))
            .cornerRadius(16)
        }
    }
}

#Preview {
    LoadingView()
}
