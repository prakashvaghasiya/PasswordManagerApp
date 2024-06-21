//
//  AccountDetailsView.swift
//  PasswordManager
//
//  Created by Prakash on 21/06/24.
//

import Foundation
import SwiftUI
import CryptoKit

struct AccountDetailsView: View {
    //MARK: Variables
    var passwordDetail: PasswordManage?
    @Binding var isPresented: Bool
    @State private var accountName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isHide: Bool = true
    @State private var isAlert = false
    @State private var isShowingToast = false
    @Environment(\.managedObjectContext) var viewContext
    var completion: (PasswordManage) -> Void
    
    //MARK: Life Cycle
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .center)) {
            VStack(alignment: .center) {
                Rectangle()
                    .fill(Color(uiColor: UIColor.App_Colors.appSepratorGrayColor))
                    .frame(width: 46, height: 4, alignment: .center)
                    .cornerRadius(2)
                
                VStack(alignment: .leading) {
                    Text("Account Details")
                        .font(
                            Font.custom("Poppins", size: 19)
                                .weight(.bold)
                        )
                        .foregroundColor(.blue)
                        .padding()
                    
                    VStack(alignment: .leading) {
                        Text("Account Type")
                            .font(
                                Font.custom("Poppins", size: 11)
                                    .weight(.regular)
                            )
                            .foregroundColor(Color(uiColor: UIColor.App_Colors.appTextTitleGrayColor))
                        Text(accountName)
                            .font(
                                Font.custom("Poppins", size: 16)
                                    .weight(.medium)
                            )
                            .foregroundColor(Color(uiColor: UIColor.App_Colors.appTextDarkGrayColor))
                            .padding(.bottom)
                        
                        Text("Username/ Email")
                            .font(
                                Font.custom("Poppins", size: 11)
                                    .weight(.regular)
                            )
                            .foregroundColor(Color(uiColor: UIColor.App_Colors.appTextTitleGrayColor))
                        Text(email)
                            .font(
                                Font.custom("Poppins", size: 16)
                                    .weight(.medium)
                            )
                            .foregroundColor(Color(uiColor: UIColor.App_Colors.appTextDarkGrayColor))
                            .padding(.bottom)
                        
                        Text("Password")
                            .font(
                                Font.custom("Poppins", size: 11)
                                    .weight(.regular)
                            )
                            .foregroundColor(Color(uiColor: UIColor.App_Colors.appTextTitleGrayColor))
                        HStack {
                            Text(isHide ? "********" : password)
                                .font(
                                    Font.custom("Poppins", size: 16)
                                        .weight(.medium)
                                )
                                .foregroundColor(Color(uiColor: UIColor.App_Colors.appTextDarkGrayColor))
                            Spacer()
                            Image(systemName: isHide ? "eye.slash" : "eye")
                                .onTapGesture {
                                    isHide.toggle()
                                }
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            // Handle Edit action
                            dataUpdate()
                        }) {
                            Text("Edit")
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
                        
                        Button(action: {
                            // Handle Delete action
                            isAlert = true
                        }) {
                            Text("Delete")
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
                    }.padding(.bottom, 30)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.App_Colors.appLightGrayColor))
            .clipShape(RoundedCornerShape(corners: [.topLeft, .topRight], radius: 25))
        }.onAppear(perform: {
            if let passwordDetail = passwordDetail {
                accountName = passwordDetail.accountType ?? ""
                email = passwordDetail.userId ?? ""
                if let data = Data(base64Encoded: (passwordDetail.userPsw ?? "")) {
                    password = (passwordDetail.userPsw ?? "").decryptPassword(psw: data, secretKey: SymmetricKey(data: (passwordDetail.symetricKey ?? Data())))
                }
            }
        })
        .alert(isPresented: $isAlert) { () -> Alert in
            Alert(title: Text("Delete"), message: Text("Are you sure you want to delete this data?"), primaryButton: .destructive(Text("Yes"), action: {
                datadelete()
            }), secondaryButton: .default(Text("No")))
        }
        .toast(isShowing: $isShowingToast, message: "Data delete successfully.")
    }
    
    //MARK: Methods
    private func dataUpdate() {
        if let passwordDetail = passwordDetail {
            completion(passwordDetail)
            isPresented = false
        }
    }
    
    // Core Data Delete Operations
    private func datadelete() {
        if let passwordDetail = passwordDetail {
            self.viewContext.delete(passwordDetail)
            
            do {
                try viewContext.save()
                isShowingToast = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    isPresented = false
                }
            } catch {
                print("Data cannot delete")
            }
        }
    }
}
