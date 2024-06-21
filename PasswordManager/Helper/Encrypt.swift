//
//  Encrypt.swift
//  PasswordManager
//
//  Created by Prakash on 21/06/24.
//

import Foundation
import CryptoKit

//MARK: - Encryption
struct Encrypt {
    static let shared = Encrypt()
    private init() {}
    
    func encryptString(_ input: String) -> Data? {
        guard let dataToEncrypt = input.data(using: .utf8) else { return nil }
        do {
            let encryptData = try Encrypt.shared.encryptData(dataToEncrypt: dataToEncrypt, key: secretKey)
            return encryptData
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        return nil
    }
    
    func decryptString(_ input: Data, secretKey: SymmetricKey) -> String? {
        do {
            let decryptData = try Encrypt.shared.decryptData(encryptedData: input, key: secretKey)
            if let decryptString = String(data: decryptData, encoding: .utf8) {
                print("Decrypted Message: \(decryptString)")
                return decryptString
            } else {
                print("failed to decrypt message")
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        return nil
    }
    
    func encryptData(dataToEncrypt: Data, key: SymmetricKey) throws -> Data {
        let cipher = try? AES.GCM.seal(dataToEncrypt, using: key)
        return cipher?.combined ?? Data()
    }
    
    func decryptData(encryptedData: Data, key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
        return try AES.GCM.open(sealedBox, using: key)
    }
}
