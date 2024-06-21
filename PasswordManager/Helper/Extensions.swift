//
//  Extensions.swift
//  PasswordManager
//
//  Created by Prakash on 21/06/24.
//

import Foundation
import CryptoKit
import SwiftUI

public extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func isValid() -> Bool {
        return self.range(
            of: #"(?=^.{7,}$)(?=^.*[A-Z].*$)(?=^.*\d.*$).*"#,
            options: .regularExpression
        ) != nil
    }
    
    func encryptPassword() -> String {
        if let pswData = Encrypt.shared.encryptString(self)  {
            return pswData.base64EncodedString()
        } else {
            return self
        }
    }
    
    func decryptPassword(psw: Data, secretKey: SymmetricKey) -> String {
        if let pswString = Encrypt.shared.decryptString(psw, secretKey: secretKey) {
            return pswString
        } else {
            return self
        }
    }
}

extension View {
    func toast(isShowing: Binding<Bool>, message: String, duration: TimeInterval = 2.0) -> some View {
        self.modifier(ToastModifier(isShowing: isShowing, message: message, duration: duration))
    }
}
