//
//  LoginView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 29.02.24.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject private var authVM: AuthViewModel
    @State private var showRegisterSheet: Bool = false
    @State private var showPasswordWithEmail: Bool = false
    
    var body: some View {
        VStack{
            Spacer()
            Text("Der Weg ist das Ziel")
                .padding(8)
                .font(.headline)
                .italic()
                .bold()
                .foregroundStyle(.cyan)
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
            Image("logo")
                .resizable()
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .scaledToFit()
                .opacity(0.8)
                .frame(width: 250, height: 250)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .padding()
            Text("Meet me at the campfire")
                .padding(8)
                .font(.headline)
                .bold()
                .foregroundStyle(.cyan)
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
            VStack{
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white).opacity(0.7)
                    .padding()
                    .overlay(
                        VStack {
                            ZStack(alignment: .trailing){
                                TextField("Email eingeben", text: $authVM.email)
                                    .textFieldStyle(.roundedBorder)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .padding()
                                if !authVM.email.isEmpty {
                                    if authVM.email.count >= 2 {
                                        RightView()
                                    } else {
                                        FalseView()
                                    }
                                }
                            }
                            ZStack(alignment: .trailing){
                                SecureField("Passwort eingeben", text: $authVM.password)
                                    .textFieldStyle(.roundedBorder)
                                    .padding()
                                if !authVM.password.isEmpty {
                                    if authVM.password.count >= 6 {
                                        RightView()
                                    } else {
                                        FalseView()
                                    }
                                }
                            }
                            ButtonTextAction(iconName: "paperplane.fill", text: "Login"){
                                if !authVM.password.isEmpty && authVM.password.count >= 6 {
                                    authVM.login()
                                }
                            }
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 6, trailing: 0))
                            .alert(isPresented: $authVM.somethingGoneWrong){
                                Alert(title: Text("Hoppla"), message: Text("Deine Anmeldung hat nicht geklappt"), dismissButton: .default(Text("OK")))
                            }
                            Divider()
                                .padding()
                            HStack {
                                Text("Noch kein Konto?")
                                    .font(.callout)
                                Button("Jetzt registrieren"){
                                    showRegisterSheet.toggle()
                                }
                                .sheet(isPresented: $showRegisterSheet) {
                                    RegisterView(showRegisterSheet: $showRegisterSheet)
                                        .presentationDetents([.medium])
                                }
                            }
                            HStack {
                                let passwordText: String = "Passwort vergessen?"
                                Button(passwordText){
                                    showPasswordWithEmail.toggle()
                                }
                                .padding(5)
                                .font(.system(size: 12))
                                .sheet(isPresented: $showPasswordWithEmail){
                                    PasswortSendWithEmailView(showPasswordWithEmail: $showPasswordWithEmail)
                                        .presentationDetents([.medium])
                                }
                            }
                        }
                            .padding()
                    )
                    .padding()
            }
        }
        .scrollContentBackground(.hidden)
        .background(
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all))
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
