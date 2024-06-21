//
//  ToastView.swift
//  PasswordManager
//
//  Created by Prakash on 21/06/24.
//

import SwiftUI

struct ToastView: View {
    var message: String
    
    var body: some View {
        Text(message)
            .foregroundColor(.white)
            .padding()
            .background(Color.black.opacity(0.8))
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .padding(.bottom, 50)
            .shadow(radius: 10)
    }
}

struct ToastModifier: ViewModifier {
    @Binding var isShowing: Bool
    var message: String
    var duration: TimeInterval = 2.0

    func body(content: Content) -> some View {
        ZStack {
            content
            if isShowing {
                VStack {
                    Spacer()
                    ToastView(message: message)
                }
                .transition(.move(edge: .bottom))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        withAnimation {
                            isShowing = false
                        }
                    }
                }
            }
        }
    }
}
