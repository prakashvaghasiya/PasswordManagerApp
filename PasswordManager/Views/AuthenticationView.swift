//
//  AuthenticationView.swift
//  PasswordManager
//
//  Created by Prakash on 21/06/24.
//

import Foundation
import SwiftUI
import LocalAuthentication

struct AuthenticationView: View {
    //MARK: Variables
    @Binding var isAuthenticated: Bool
    //MARK: Life cycle
    var body: some View {
        VStack(alignment: .center) {
            Text("You want to enable authentication?")
                .font(
                    Font.custom("Poppins", size: 19)
                        .weight(.bold)
                )
            
            Button(action: {
                authenticateBiomatricAndFace()
            }) {
                Text("Yes")
                    .font(
                        Font.custom("Poppins", size: 15)
                            .weight(.semibold)
                    )
                    .frame(height: 40)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color(UIColor.App_Colors.appButtonRedColor))
                    .cornerRadius(20)
            }
            .padding()
            
            if !(userDefaultData.authentication.getDefaultValue() as? Bool ?? false) {
                Button(action: {
                    isAuthenticated = true
                    userDefaultData.authentication.saveDefaultValue(false)
                }) {
                    Text("No")
                        .font(
                            Font.custom("Poppins", size: 15)
                                .weight(.semibold)
                        )
                        .frame(height: 40)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color(UIColor.App_Colors.appButtonBlackColor))
                        .cornerRadius(20)
                }
                .padding()
            }
        }
        .padding()
        .onAppear {
            if (userDefaultData.authentication.getDefaultValue() as? Bool ?? false) {
                authenticateBiomatricAndFace()
            }
        }
    }
    
    //Face & Touch authentication
    func authenticateBiomatricAndFace() {
        let context = LAContext()
        var error: NSError?
        
        // Check if the device is capable of biometric authentication
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Log in to your account"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        userDefaultData.authentication.saveDefaultValue(true)
                        self.isAuthenticated = true
                    } else {
                        authenticateWithPasscode()
                    }
                }
            }
        } else {
            if let laError = error as? LAError {
                // Handle the specific error code
                switch laError.code {
                case .biometryNotAvailable:
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                case .biometryNotEnrolled:
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                case .biometryLockout:
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                default:
                    self.isAuthenticated = true
                }
            } else {
                self.isAuthenticated = true
            }
        }
    }
    
    //Passcode authentication
    func authenticateWithPasscode() {
        let context = LAContext()
        let reason = "Please enter your passcode"
        
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
            DispatchQueue.main.async {
                if success {
                    self.isAuthenticated = true
                } else {
                    
                }
            }
        }
    }
}
