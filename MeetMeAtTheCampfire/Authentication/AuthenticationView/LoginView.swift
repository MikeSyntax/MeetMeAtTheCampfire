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
            Spacer()
            VStack {
                Spacer()
                ZStack(alignment: .trailing){
                    TextField("Email eingeben", text: $authVM.email, onCommit: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    })
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(EdgeInsets(top: 15, leading: 20, bottom: 0, trailing: 20))
                    if !authVM.email.isEmpty {
                        if authVM.email.count >= 2 {
                            RightView()
                        } else {
                            FalseView()
                        }
                    }
                }
                ZStack(alignment: .trailing){
                    SecureField("Passwort eingeben", text: $authVM.password, onCommit: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    })
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(EdgeInsets(top: 15, leading: 20, bottom: 10, trailing: 20))
                    if !authVM.password.isEmpty {
                        if authVM.password.count >= 6 {
                            RightView()
                        } else {
                            FalseView()
                        }
                    }
                }
                Spacer()
                ButtonTextAction(iconName: "paperplane.fill", text: "Login"){
                    if !authVM.password.isEmpty && authVM.password.count >= 6 {
                        authVM.login()
                    }
                }
                .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                .alert(isPresented: $authVM.somethingGoneWrong){
                    Alert(title: Text("Hoppla"), message: Text("Deine Anmeldung hat nicht geklappt"), dismissButton: .default(Text("OK")))
                }
                Spacer()
                Divider()
                Spacer()
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
                .padding()
                let passwordText: String = "Passwort vergessen?"
                Button(passwordText){
                    showPasswordWithEmail.toggle()
                }
                .padding()
                .font(.system(size: 14))
                Spacer()
                Spacer()
                    .sheet(isPresented: $showPasswordWithEmail){
                        PasswortSendWithEmailView(showPasswordWithEmail: $showPasswordWithEmail)
                            .presentationDetents([.medium])
                    }
            }
            .frame(width: 320, height: 320)
            .background(Color.white.opacity(0.8))
            .cornerRadius(10)
            
        }
        .scrollContentBackground(.hidden)
        .background(
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all))
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}


//
//
//
//                Spacer()
//                ButtonTextAction(iconName: "paperplane.fill", text: "Login"){
//                    if !authVM.password.isEmpty && authVM.password.count >= 6 {
//                        authVM.login()
//                    }
//                }
//                .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
//                .alert(isPresented: $authVM.somethingGoneWrong){
//                    Alert(title: Text("Hoppla"), message: Text("Deine Anmeldung hat nicht geklappt"), dismissButton: .default(Text("OK")))
//                }
//                Spacer()
//                HStack {
//                    Text("Noch kein Konto?")
//                        .font(.system(size: 14))
//                    Button("Jetzt registrieren"){
//                        showRegisterSheet.toggle()
//                    }
//                    .sheet(isPresented: $showRegisterSheet) {
//                        RegisterView(showRegisterSheet: $showRegisterSheet)
//                            .presentationDetents([.medium])
//                    }
//                    .font(.system(size: 14))
//                }
//                .padding()
//                let passwordText: String = "Passwort vergessen?"
//                Button(passwordText){
//                    showPasswordWithEmail.toggle()
//                }
//                .padding()
//                .font(.system(size: 14))
//                Spacer()
//
//                    .sheet(isPresented: $showPasswordWithEmail){
//                        PasswortSendWithEmailView(showPasswordWithEmail: $showPasswordWithEmail)
//                            .presentationDetents([.medium])
//                    }
//            }
//            .background(Color.white.opacity(0.8))
//            .cornerRadius(10)
//            .padding()
//
//
//
//
//
//
//
//
//
//
//        }
//        .scrollContentBackground(.hidden)
//        .background(
//            Image("background")
//                .resizable()
//                .scaledToFill()
//                .ignoresSafeArea(.all))
//        .onTapGesture {
//            // Tastatur schließen, wenn auf die View geklickt wird
//            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//        }
//    }
//}
//
//#Preview {
//    LoginView()
//        .environmentObject(AuthViewModel())
//}
