//
//  DeleteAccountView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 05.05.24.
//

import SwiftUI

struct DeleteAccountView: View {
    
    @State private var userLoggedInForDeleting: Bool = false
    @EnvironmentObject var authVm: AuthViewModel
    @Binding var showPasswordConfirmationSheet: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
                VStack(alignment: .leading){
                    Text("Email")
                        .font(.system(size: 10))
                        .padding(EdgeInsets(top: 0, leading: 60, bottom: 0, trailing: 60))
                    ZStack(alignment: .trailing){
                        TextField("Email eingeben", text: $authVm.email)
                            .font(.system(size: 15).bold())
                            .textFieldStyle(.roundedBorder)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .padding(1)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.cyan, lineWidth: 2)
                            )
                            .padding(EdgeInsets(top: 0, leading: 60, bottom: 10, trailing: 60))
                        if !authVm.email.isEmpty {
                            if authVm.email.count >= 2 {
                                RightView()
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 45))
                            } else {
                                FalseView()
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 45))
                            }
                        }
                    }
                }
                VStack(alignment: .leading){
                    Text("Passwort")
                        .font(.system(size: 10))
                        .padding(EdgeInsets(top: 0, leading: 60, bottom: 0, trailing: 60))
                    ZStack(alignment: .trailing){
                        SecureField("Passwort eingeben", text: $authVm.password)
                            .font(.system(size: 15).bold())
                            .textFieldStyle(.roundedBorder)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .padding(1)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.cyan, lineWidth: 2)
                            )
                            .padding(EdgeInsets(top: 0, leading: 60, bottom: 10, trailing: 60))
                        if !authVm.password.isEmpty {
                            if authVm.password.count >= 6 {
                                RightView()
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 45))
                            } else {
                                FalseView()
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 45))
                            }
                        }
                    }
                }
                
                ButtonTextAction(iconName: "person.fill.questionmark", text: "Einloggen", action: {
                    authVm.login()
                    userLoggedInForDeleting.toggle()
                })
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 50, trailing: 0))
                
                if userLoggedInForDeleting {
                    ButtonDestructiveTextAction(iconName: "trash", text: "Account unwiederbringlich löschen", action: {
                            authVm.deleteUserData {
                                authVm.deleteAccount {
                                    authVm.logout()
                                    dismiss()
                                }
                            }
                    })
                }
                Spacer()
            }
            .keyboardType(.emailAddress)
            .submitLabel(.done)
            .navigationBarTitle("Account entgültig löschen", displayMode: .inline)
            .scrollContentBackground(.hidden)
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
                    .ignoresSafeArea(.all))
            .toolbar{
                Button("Abbrechen"){
                    dismiss()
                }
            }
            
        }
    }
}

#Preview {
    DeleteAccountView(showPasswordConfirmationSheet: .constant(false))
        .environmentObject(AuthViewModel())
}
