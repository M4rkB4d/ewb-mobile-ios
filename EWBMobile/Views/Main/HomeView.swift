//
//  HomeView.swift
//  EWBMobile
//
//  Created by Mark Paul Ramirez on 1/17/26.
//

import SwiftUI

// MARK: - Home View

struct HomeView: View {
    @StateObject private var authService = AuthService.shared
    @State private var selectedModule: BankingModule?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Account Card
                    AccountCard(user: authService.currentUser)
                    
                    // Quick Actions
                    QuickActionsGrid(onModuleSelected: { module in
                        selectedModule = module
                    })
                    
                    // Services Section
                    ServicesSection(onModuleSelected: { module in
                        selectedModule = module
                    })
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("EWB Mobile")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.ewbBlue)
                    }
                }
            }
            .navigationDestination(item: $selectedModule) { module in
                ModuleWebViewScreen(module: module)
            }
        }
    }
}

// MARK: - Account Card

struct AccountCard: View {
    let user: User?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Good \(greeting)!")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text(user?.name ?? "User")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Text(user?.name.prefix(1).uppercased() ?? "U")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(Color.ewbBlue)
            
            // Balance Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Available Balance")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(alignment: .firstTextBaseline) {
                    Text((user?.accountBalance ?? 0).asCurrency)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Account No.")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text(user?.accountNumber ?? "----")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                }
            }
            .padding()
            .background(Color(.systemGroupedBackground))
        }
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
    
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Morning"
        case 12..<17: return "Afternoon"
        default: return "Evening"
        }
    }
}

// MARK: - Quick Actions Grid

struct QuickActionsGrid: View {
    let onModuleSelected: (BankingModule) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline)
            
            HStack(spacing: 16) {
                ForEach(BankingModule.modules) { module in
                    QuickActionButton(module: module) {
                        onModuleSelected(module)
                    }
                }
            }
        }
    }
}

struct QuickActionButton: View {
    let module: BankingModule
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(module.color.opacity(0.1))
                        .frame(width: 54, height: 54)
                    
                    Image(systemName: module.icon)
                        .font(.system(size: 22))
                        .foregroundColor(module.color)
                }
                
                Text(module.name.split(separator: " ").first ?? "")
                    .font(.caption)
                    .foregroundColor(.primary)
                
                Text(module.name.split(separator: " ").dropFirst().joined(separator: " "))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Services Section

struct ServicesSection: View {
    let onModuleSelected: (BankingModule) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Services")
                .font(.headline)
            
            VStack(spacing: 12) {
                ForEach(BankingModule.modules) { module in
                    ServiceRow(module: module) {
                        onModuleSelected(module)
                    }
                }
            }
        }
    }
}

struct ServiceRow: View {
    let module: BankingModule
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(module.color.opacity(0.1))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: module.icon)
                        .font(.system(size: 20))
                        .foregroundColor(module.color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(module.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(module.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .cornerRadius(12)
        }
    }
}

// MARK: - BankingModule Extension for NavigationDestination

extension BankingModule: Hashable {
    static func == (lhs: BankingModule, rhs: BankingModule) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

#Preview {
    HomeView()
}
