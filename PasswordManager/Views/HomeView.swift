//
//  HomeView.swift
//  PasswordManager
//
//  Created by Prakash on 21/06/24.
//

import SwiftUI
import CommonCrypto
struct HomeView: View {
    //MARK: Variables
    @State private var isPresentingNewAccountSheet = false
    @State private var isPresentingDetailAccountSheet = false
    @State private var selectedItem: PasswordManage?
    @FetchRequest(sortDescriptors: []) private var passwordManagerList: FetchedResults<PasswordManage>
    
    init() {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = UIColor.App_Colors.bgColor
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = .white
    }
    
    //MARK: Life Cycle
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.App_Colors.bgColor)
                VStack(alignment: (passwordManagerList.count != 0) ? .leading : .center) {
                    Divider()
                    if (passwordManagerList.count != 0) {
                        ForEach(passwordManagerList, id: \.self) { detail in
                            PasswordRow(name: detail.accountType ?? "")
                                .onTapGesture {
                                    selectedItem = detail
                                    isPresentingDetailAccountSheet = true
                                }
                        }.frame(maxWidth: .infinity)
                    } else {
                        Spacer()
                        Text("No Record Found")
                            .font(
                                Font.custom("Poppins", size: 20)
                                    .weight(.bold)
                            )
                            .frame(maxWidth: .infinity)
                    }
                    Spacer()
                    if !isPresentingNewAccountSheet {
                        HStack {
                            Spacer()
                            Button(action: {
                                selectedItem = nil
                                isPresentingNewAccountSheet.toggle()
                            }) {
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .padding()
                                    .background(Color(UIColor.App_Colors.appButtonColor))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    .shadow(radius: 2)
                            }
                            .padding()
                        }
                    }
                }
                .navigationBarItems(leading:
                                        Text("Password Manager").font(
                                            Font.custom("Poppins", size: 21)
                                                .weight(.medium)
                                        ))
                .blur(radius: isPresentingNewAccountSheet || isPresentingDetailAccountSheet ? 2.0 : 0.0)
            }
            .fullScreenCover(isPresented: $isPresentingDetailAccountSheet, content: {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isPresentingDetailAccountSheet = false
                    }
                AccountDetailsView(passwordDetail: selectedItem, isPresented: $isPresentingDetailAccountSheet, completion: { passwordManger in
                    selectedItem = passwordManger
                    isPresentingNewAccountSheet = true
                })
                .background(TransparentDialogView())
                .edgesIgnoringSafeArea(.all)
                .transition(.move(edge: .bottom))
            })
            .fullScreenCover(isPresented: $isPresentingNewAccountSheet, content: {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isPresentingNewAccountSheet = false
                    }
                
                NewAccountView(passwordDetail: selectedItem, isPresented: $isPresentingNewAccountSheet, dataListArray: passwordManagerList.map { $0 })
                    .background(TransparentDialogView())
                    .edgesIgnoringSafeArea(.all)
                    .transition(.move(edge: .bottom))
            })
        }
    }
}

struct TransparentDialogView: UIViewRepresentable {
  func makeUIView(context: Context) -> UIView {
    let view = UIView()
    DispatchQueue.main.async {
      let almostTransparent = UIColor(red: 1, green: 1, blue: 1, alpha: 0.30)
      view.superview?.superview?.backgroundColor = almostTransparent
    }
    return view
  }

 func updateUIView(_ uiView: UIView, context: Context) {}
}

struct RoundedCornerShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
