//
//  NewAccountView.swift
//  PasswordManager
//
//  Created by Prakash on 21/06/24.
//

import SwiftUI
import CryptoKit

struct NewAccountView: View {
    //MARK: Variables
    var passwordDetail: PasswordManage?
    @Binding var isPresented: Bool
    @State private var accountName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isAlert = false
    @State private var msg: String = ""
    @State private var isShowingToast = false
    @State var passwordDetailContext: PasswordManage?
    var dataListArray: [PasswordManage] = []
    @Environment(\.managedObjectContext) var viewContext
    
    //MARK: Life Cycle
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    Rectangle()
                        .fill(Color(uiColor: UIColor.App_Colors.appSepratorGrayColor))
                        .frame(width: 46, height: 4, alignment: .center)
                        .cornerRadius(2)
                    
                    VStack {
                        TextField("Account Name", text: $accountName)
                            .frame(height: 18)
                            .padding()
                            .foregroundColor(Color.black)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(UIColor.systemGray5), lineWidth: 1)
                            )
                            .padding(.horizontal)
                            .padding(.top, 30)
                        
                        TextField("Username/ Email", text: $email)
                            .frame(height: 18)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(UIColor.systemGray5), lineWidth: 1)
                            )
                            .padding(.horizontal)
                            .padding(.top, 10)
                        
                        SecureInputView("Password", text: $password)
                            .frame(height: 18)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(UIColor.systemGray5), lineWidth: 1)
                            )
                            .padding(.horizontal)
                            .padding(.top, 10)
                        
                        Button(action: {
                            // Action for adding a new account
                            if let msg = validation() {
                                self.msg = msg
                                isAlert = true
                            } else {
                                saveUpdateData()
                            }
                        }) {
                            Text(passwordDetail != nil ? "Update Account" : "Add New Account")
                                .font(
                                    Font.custom("Poppins", size: 15)
                                        .weight(.semibold)
                                )
                                .frame(height: 15)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(UIColor.App_Colors.appButtonBlackColor))
                                .cornerRadius(20)
                                .padding(.horizontal)
                                .padding(.top, 30)
                        }
                        Spacer()
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color(UIColor.App_Colors.bgColor2))
            .clipShape(RoundedCornerShape(corners: [.topLeft, .topRight], radius: 25))
            .edgesIgnoringSafeArea(.bottom)
        }
        .onAppear(perform: {
            if let passwordDetail = passwordDetail {
                passwordDetailContext = passwordDetail
                accountName = passwordDetail.accountType ?? ""
                email = passwordDetail.userId ?? ""
                if let data = Data(base64Encoded: (passwordDetail.userPsw ?? "")) {
                    password = (passwordDetail.userPsw ?? "").decryptPassword(psw: data, secretKey: SymmetricKey(data: (passwordDetail.symetricKey ?? Data())))
                }
            }
        })
        .alert(isPresented: $isAlert) {
            if (self.msg == "This account type already exist do you want to update them?") {
                Alert(title: Text("Alert"), message: Text(self.msg), primaryButton: .destructive(Text("Yes"), action: {
                    if let index = dataListArray.firstIndex(where: {($0.accountType ?? "").lowercased() == accountName.lowercased()}) {
                        passwordDetailContext = dataListArray[index]
                        saveUpdateData()
                    }
                }), secondaryButton: .default(Text("No")))
            } else {
                Alert(title: Text(""), message: Text(msg))
            }
        }
        .toast(isShowing: $isShowingToast, message: (passwordDetail == nil) ? "Data save successfully." : "Data update successfully.")
    }

    //MARK: Methods
    private func validation() -> String? {
        if accountName.isEmpty {
            return "Please enter account name"
        } else if email.isEmpty {
            return "Please enter User name/Email"
        } else if !email.isValidEmail() {
            return "Please enter valid Email"
        } else if password.isEmpty {
            return "Please enter password"
        } else if !password.isValid() {
            return "Please enter password at least 7 characters, one uppercase letter and one number"
        } else if dataListArray.contains(where: {($0.accountType ?? "").lowercased() == accountName.lowercased()}) && (passwordDetail == nil) {
            return "This account type already exist do you want to update them?"
        }
        return nil
    }
    
    // Core Data Save & Update Operations
    func saveUpdateData() {
        if passwordDetailContext == nil {
            passwordDetailContext = PasswordManage(context: self.viewContext)
            passwordDetailContext?.id = "\(UUID())"
        }
        passwordDetailContext?.accountType = accountName
        passwordDetailContext?.userId = email
        passwordDetailContext?.userPsw = password.encryptPassword()
        passwordDetailContext?.symetricKey = secretKey.withUnsafeBytes { Data($0) }
        
        do {
            try self.viewContext.save()
            isShowingToast = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                isPresented = false
            }
        } catch {
            print("Password cannot save")
        }
    }
}
