//
//  PasswordRow.swift
//  PasswordManager
//
//  Created by Prakash on 21/06/24.
//

import Foundation
import SwiftUI

struct PasswordRow: View {
    let name: String
    
    var body: some View {
        HStack {
            Text(name)
                .font(
                    Font.custom("Poppins", size: 18)
                        .weight(.semibold)
                )
                .foregroundStyle(Color.black)
                .padding(.leading, 20)
            Text("********")
                .font(
                    Font.custom("Poppins", size: 18)
                        .weight(.semibold)
                )
                .foregroundColor(Color(uiColor: UIColor.App_Colors.appTextGrayColor))
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .padding(.trailing, 15)
            
        }
        .frame(height: 66)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(33)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal , 15)
        .padding(.vertical, 8)
    }
}
