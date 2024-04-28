//
//  LoginView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 29.02.24.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject private var authVm: AuthViewModel
    @State private var showRegisterSheet: Bool = false
    @State private var showPasswordWithEmail: Bool = false
    
    var body: some View {
        VStack{
            VStack{
                Spacer()
                VStack{
                    ZStack{
                        Image(.logo)
                            .resizable()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .opacity(0.8)
                        CircularTextView(title: "   Deine Camper App -Meet me at the campfire".uppercased(), radius: 125)
                    }
                    .padding(EdgeInsets(top: 35, leading: 0, bottom: 0, trailing: 0))
                    VStack{
                        VStack{
                            Text("Meet me at the campfire")
                            Text("Der Weg ist das Ziel")
                        }
                        .frame(width: 210)
                        .padding(8)
                        .font(.headline)
                        .italic()
                        .bold()
                        .foregroundStyle(.cyan)
                       
                        .cornerRadius(10)
                    }
                    .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
                }
                .padding(.top)
                VStack {
                    Spacer()
                    VStack{
                        VStack(alignment: .leading){
                            Text("Email")
                                .font(.system(size: 10))
                                .padding(EdgeInsets(top: 0, leading: 60, bottom: 0, trailing: 60))
                            ZStack(alignment: .trailing){
                            TextField("Email eingeben", text: $authVm.email)
                                .font(.system(size: 17))
                                      .padding(4)
                                      .background(.white.opacity(0.4))
                                      .cornerRadius(6)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .padding(EdgeInsets(top: 0, leading: 60, bottom: 10, trailing: 60))
                                if !authVm.email.isEmpty {
                                    if authVm.email.count >= 2 {
                                        RightView()
                                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 45))
                                    } else {
                                        FalseView()
                                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 45))
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
                                .font(.system(size: 17))
                                      .padding(4)
                                      .background(.white.opacity(0.4))
                                      .cornerRadius(6)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .padding(EdgeInsets(top: 0, leading: 60, bottom: 10, trailing: 60))
                                if !authVm.password.isEmpty {
                                    if authVm.password.count >= 6 {
                                        RightView()
                                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 45))
                                    } else {
                                        FalseView()
                                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 45))
                                    }
                                }
                            }
                        }
                    }
                    
                    .keyboardType(.emailAddress)
                    .submitLabel(.done)
                    ButtonTextAction(iconName: "paperplane.fill", text: "Login"){
                        if !authVm.password.isEmpty && authVm.password.count >= 6 {
                            authVm.login()
                        }
                    }
                    .padding(EdgeInsets(top: 16, leading: 0, bottom: 8, trailing: 0))
                    .alert(isPresented: $authVm.loginFailedAlert){
                        Alert(title: Text("Hoppla"), message: Text("Deine Anmeldung hat nicht geklappt"), dismissButton: .default(Text("OK")))
                    }
                    Divider()
                        .padding()
                    HStack {
                        Text("Noch kein Konto?")
                            .font(.system(size: 14))
                        Button("Jetzt registrieren"){
                            showRegisterSheet.toggle()
                        }
                        .sheet(isPresented: $showRegisterSheet) {
                            RegisterView(showRegisterSheet: $showRegisterSheet)
                                .presentationDetents([.medium])
                        }
                        .font(.system(size: 14))
                    }
                    let passwordText: String = "Passwort vergessen?"
                    Button(passwordText){
                        showPasswordWithEmail.toggle()
                    }
                    .padding()
                    .font(.system(size: 14))
                        .sheet(isPresented: $showPasswordWithEmail){
                            PasswortSendWithEmailView(showPasswordWithEmail: $showPasswordWithEmail)
                                .presentationDetents([.medium])
                        }
                }
            }
            .scrollContentBackground(.hidden)
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
                    .ignoresSafeArea(.all))
        }
        .background(Color(UIColor.systemBackground))
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
