//
//  Module.swift
//  EWBMobile
//
//  Created by Mark Paul Ramirez on 1/17/26.
//

import Foundation
import SwiftUI

// MARK: - Banking Module

struct BankingModule: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let icon: String
    let color: Color
    let webURL: String
    
    static let modules: [BankingModule] = [
        BankingModule(
            name: "Bills Payment",
            description: "Pay your utility bills",
            icon: "doc.text.fill",
            color: .blue,
            webURL: Constants.WebModules.billsPayment
        ),
        BankingModule(
            name: "Fund Transfer",
            description: "Send money to other accounts",
            icon: "arrow.left.arrow.right",
            color: .green,
            webURL: Constants.WebModules.fundTransfer
        ),
        BankingModule(
            name: "Buy Load",
            description: "Purchase prepaid mobile load",
            icon: "phone.fill",
            color: .orange,
            webURL: Constants.WebModules.buyLoad
        )
    ]
}

// MARK: - Quick Action

struct QuickAction: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let destination: QuickActionDestination
    
    enum QuickActionDestination {
        case module(BankingModule)
        case native(NativeScreen)
    }
    
    enum NativeScreen {
        case transactionHistory
        case accountDetails
        case settings
    }
    
    static let actions: [QuickAction] = [
        QuickAction(
            name: "Pay Bills",
            icon: "doc.text.fill",
            color: .blue,
            destination: .module(BankingModule.modules[0])
        ),
        QuickAction(
            name: "Transfer",
            icon: "arrow.left.arrow.right",
            color: .green,
            destination: .module(BankingModule.modules[1])
        ),
        QuickAction(
            name: "Buy Load",
            icon: "phone.fill",
            color: .orange,
            destination: .module(BankingModule.modules[2])
        ),
        QuickAction(
            name: "History",
            icon: "clock.fill",
            color: .purple,
            destination: .native(.transactionHistory)
        )
    ]
}
