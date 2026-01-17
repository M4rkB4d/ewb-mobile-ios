//
//  SettingsView.swift
//  EWBMobile
//
//  Created by Mark Paul Ramirez on 1/17/26.
//

import SwiftUI

// MARK: - Settings View

struct SettingsView: View {
    @StateObject private var authService = AuthService.shared
    @Environment(\.dismiss) private var dismiss
    @State private var showingLogoutAlert = false
    
    var body: some View {
        List {
            // Profile Section
            Section {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.ewbBlue)
                            .frame(width: 60, height: 60)
                        
                        Text(authService.currentUser?.name.prefix(1).uppercased() ?? "U")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(authService.currentUser?.name ?? "User")
                            .font(.headline)
                        
                        Text(authService.currentUser?.email ?? "")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 8)
            }
            
            // Account Section
            Section("Account") {
                SettingsRow(icon: "person.fill", title: "Profile", color: .blue)
                SettingsRow(icon: "creditcard.fill", title: "My Accounts", color: .green)
                SettingsRow(icon: "bell.fill", title: "Notifications", color: .orange)
            }
            
            // Security Section
            Section("Security") {
                SettingsRow(icon: "lock.fill", title: "Change Password", color: .purple)
                SettingsRow(icon: "faceid", title: "Biometric Login", color: .blue)
                SettingsRow(icon: "shield.fill", title: "Privacy Settings", color: .green)
            }
            
            // Support Section
            Section("Support") {
                SettingsRow(icon: "questionmark.circle.fill", title: "Help Center", color: .blue)
                SettingsRow(icon: "phone.fill", title: "Contact Us", color: .green)
                SettingsRow(icon: "doc.text.fill", title: "Terms & Conditions", color: .gray)
            }
            
            // App Info
            Section("About") {
                HStack {
                    Text("Version")
                    Spacer()
                    Text(Constants.App.version)
                        .foregroundColor(.secondary)
                }
            }
            
            // Logout Section
            Section {
                Button(role: .destructive) {
                    showingLogoutAlert = true
                } label: {
                    HStack {
                        Spacer()
                        Text("Log Out")
                            .fontWeight(.semibold)
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Log Out", isPresented: $showingLogoutAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Log Out", role: .destructive) {
                authService.logout()
            }
        } message: {
            Text("Are you sure you want to log out?")
        }
    }
}

// MARK: - Settings Row

struct SettingsRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(color.opacity(0.1))
                    .frame(width: 30, height: 30)
                
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(color)
            }
            
            Text(title)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
