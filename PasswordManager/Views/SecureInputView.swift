//
//  SecureInputView.swift
//  PasswordManager
//
//  Created by Prakash on 21/06/24.
//

import Foundation
import SwiftUI

struct SecureInputView: View {
    //MARK: Variables
    @Binding private var text: String
    @State private var isSecured: Bool = true
    private var title: String
    
    //MARK: Life cycle
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Group {
                if isSecured {
                    SecureField(title, text: $text)
                } else {
                    TextField(title, text: $text)
                }
            }.padding(.trailing, 32)

            Button(action: {
                isSecured.toggle()
            }) {
                Image(systemName: self.isSecured ? "eye.slash" : "eye")
                    .accentColor(.gray)
            }
        }
    }
}
