//
//  PasswordManagerApp.swift
//  PasswordManager
//
//  Created by Prakash on 21/06/24.
//

import SwiftUI
import LocalAuthentication
@main
struct PasswordManagerApp: App {
    // MARK: Variables
    @StateObject private var manager: PasswordManagerModel = PasswordManagerModel()
    @State var isAuthenticated = false
    
    // MARK: Life Cycle
    var body: some Scene {
        WindowGroup {
            if isAuthenticated {
                HomeView()
                    .environmentObject(manager)
                    .environment(\.managedObjectContext, manager.container.viewContext)
            } else {
                AuthenticationView(isAuthenticated: $isAuthenticated)
            }
        }
    }
}
