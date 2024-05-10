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
                            .shadow(color: Color.cyan, radius: 4)
                            .frame(width: 140, height: 200)
                            .clipShape(Circle())
                            .opacity(0.7)
                        RoundedView(title: "   Deine Camper App -Meet me at the campfire".uppercased(), radius: 140)
                    }
                    .padding(EdgeInsets(top: 35, leading: 0, bottom: 0, trailing: 0))
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
                        .padding(EdgeInsets(top: 15, leading: 0, bottom: 20, trailing: 0))
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
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
            }
            .scrollContentBackground(.hidden)
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
                    .ignoresSafeArea(.all))
        }
        .onDisappear{
            authVm.removeListener()
        }
        .background(Color(UIColor.systemBackground))
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
