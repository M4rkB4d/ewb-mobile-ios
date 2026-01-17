//
//  LoginView.swift
//  EWBMobile
//
//  Created by Mark Paul Ramirez on 1/17/26.
//

import SwiftUI

// MARK: - Login View

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        ZStack {
            // Background gradient with EWB colors
            LinearGradient(
                colors: [Color.ewbBlue, Color.ewbBlue.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    Spacer().frame(height: 60)
                    
                    // Logo
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "building.columns.fill")
                                .font(.system(size: 44))
                                .foregroundColor(.white)
                        }
                        
                        Text("EWB Mobile")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Your banking companion")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    // Login Form
                    VStack(spacing: 20) {
                        // Error Message
                        if let error = viewModel.errorMessage {
                            HStack {
                                Image(systemName: "exclamationmark.circle.fill")
                                Text(error)
                            }
                            .font(.subheadline)
                            .foregroundColor(.errorRed)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.errorRed.opacity(0.1))
                            .cornerRadius(8)
                        }
                        
                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.secondary)
                                
                                TextField("Enter your email", text: $viewModel.email)
                                    .textFieldStyle(.plain)
                                    .autocorrectionDisabled()
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.secondary)
                                
                                SecureField("Enter your password", text: $viewModel.password)
                                    .textFieldStyle(.plain)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }
                        
                        // Login Button
                        PrimaryButton(
                            title: "Sign In",
                            isLoading: viewModel.isLoading
                        ) {
                            Task {
                                await viewModel.login()
                            }
                        }
                        .padding(.top, 8)
                    }
                    .padding(24)
                    .background(Color(.systemGroupedBackground))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                    .padding(.horizontal)
                    
                    // Demo Credentials
                    VStack(spacing: 8) {
                        Text("Demo Credentials")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text("demo@example.com / password123")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
