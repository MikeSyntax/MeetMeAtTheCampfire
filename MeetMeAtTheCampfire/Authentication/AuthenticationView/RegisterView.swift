//
//  RegisterView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 29.02.24.
//

import SwiftUI

struct RegisterView: View {
    
    @EnvironmentObject private var authVm: AuthViewModel
    @Binding var showRegisterSheet: Bool
    
    var body: some View {
        NavigationStack{
            VStack {
                Spacer()
                VStack{
                    VStack(alignment: .leading){
                        Text("Benutzername")
                            .font(.system(size: 10))
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        ZStack(alignment: .trailing){
                            TextField("Benutzernamen eingeben", text: $authVm.userName)
                                .font(.system(size: 17).bold())
                                .padding(3)
                                .background(.cyan.opacity(0.4))
                                .cornerRadius(6)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .textFieldStyle(.roundedBorder)
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                            if !authVm.userName.isEmpty {
                                if authVm.userName.count >= 2 {
                                    RightView()
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 7))
                                } else {
                                    FalseView()
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 7))
                                }
                            }
                        }
                    }
                    VStack(alignment: .leading){
                        Text("Email")
                            .font(.system(size: 10))
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        ZStack(alignment: .trailing){
                            TextField("Email eingeben", text: $authVm.email)
                                .font(.system(size: 17).bold())
                                .padding(3)
                                .background(.cyan.opacity(0.4))
                                .cornerRadius(6)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .textFieldStyle(.roundedBorder)
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                            if !authVm.email.isEmpty {
                                if authVm.email.count >= 2 {
                                    RightView()
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 7))
                                } else {
                                    FalseView()
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 7))
                                }
                            }
                        }
                    }
                    VStack(alignment: .leading){
                        Text("Passwort")
                            .font(.system(size: 10))
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        ZStack(alignment: .trailing){
                            SecureField("Passwort eingeben", text: $authVm.password)
                                .font(.system(size: 17).bold())
                                .padding(3)
                                .background(.cyan.opacity(0.4))
                                .cornerRadius(6)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .textFieldStyle(.roundedBorder)
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                            if !authVm.password.isEmpty {
                                if authVm.password.count >= 6 {
                                    RightView()
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 7))
                                } else {
                                    FalseView()
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 7))
                                }
                            }
                        }
                    }
                    VStack(alignment: .leading){
                        Text("Passwort wiederholen")
                            .font(.system(size: 10))
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        ZStack(alignment: .trailing){
                            SecureField("Passwort wiederholen", text: $authVm.confirmPassword)
                                .font(.system(size: 17).bold())
                                .padding(3)
                                .background(.cyan.opacity(0.4))
                                .cornerRadius(6)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .textFieldStyle(.roundedBorder)
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                            if (!authVm.confirmPassword.isEmpty) {
                                if  (authVm.password == authVm.confirmPassword) {
                                    RightView()
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 7))
                                } else {
                                    FalseView()
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 7))
                                }
                            }
                        }
                    }
                }
                .keyboardType(.emailAddress)
                .submitLabel(.done)
                .padding(.bottom)
                VStack{
                    ButtonTextAction(iconName: "paperplane.fill", text: "Registrieren"){
                        if (!authVm.email.isEmpty) && (!authVm.userName.isEmpty) && (authVm.password == authVm.confirmPassword) && (!authVm.password.isEmpty) && (!authVm.confirmPassword.isEmpty){
                            authVm.register()
                        }
                    }
                    .alert(isPresented: $authVm.registerSuccessfullAlert){
                        Alert(title: Text("Hallo \(authVm.userName)"), message: Text("Deine Anmeldung war erfolgreich,\n du kannst dich jetzt einloggen"), dismissButton: .default(Text("OK"), action: {
                            showRegisterSheet.toggle()
                        }))
                    }
                }
                .padding(EdgeInsets(top: 25, leading: 0, bottom: 25, trailing: 0))
            }
            .navigationTitle("Jetzt registrieren")
            .navigationBarTitleDisplayMode(.inline)
            .padding(40)
            .toolbar(content: {
                Button("Zurück") {
                    showRegisterSheet.toggle()
                }
            })
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
                    .ignoresSafeArea(.all))
        }
        .alert(isPresented: $authVm.registerFailedAlert){
            Alert(title: Text("Hoppla \(authVm.userName)"), message: Text("Deine Registrierung hat nicht geklappt"), dismissButton: .default(Text("OK")))
        }
        .background(Color(UIColor.systemBackground))
    }
}

#Preview {
    RegisterView(showRegisterSheet: .constant(false))
        .environmentObject(AuthViewModel())
}


