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
                Text("Bitte registriere Dich!")
                    .font(.title)
                    .padding(4)
                    .italic()
                    .bold()
                    .foregroundStyle(.gray)
                VStack(alignment: .leading){
                    Text("Benutzername")
                        .font(.system(size: 10))
                        .foregroundColor(.primary)
                        .padding(.leading)
                    ZStack(alignment: .trailing){
                        TextField("Benutzernamen eingeben", text: $authVm.userName)
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding(.leading)
                            .padding(.trailing)
                        if !authVm.userName.isEmpty {
                            if authVm.userName.count >= 2 {
                                RightView()
                            } else {
                                FalseView()
                            }
                        }
                    }
                }
                Spacer()
                VStack(alignment: .leading){
                    Text("Email")
                        .font(.system(size: 10))
                        .foregroundColor(.primary)
                        .padding(.leading)
                    ZStack(alignment: .trailing){
                        TextField("Email eingeben", text: $authVm.email)
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding(.leading)
                            .padding(.trailing)
                        if !authVm.email.isEmpty {
                            if authVm.email.count >= 2 {
                                RightView()
                            } else {
                                FalseView()
                            }
                        }
                    }
                }
                Spacer()
                VStack(alignment: .leading){
                    Text("Passwort")
                        .font(.system(size: 10))
                        .foregroundColor(.primary)
                        .padding(.leading)
                    ZStack(alignment: .trailing){
                        SecureField("Passwort eingeben", text: $authVm.password)
                            .textFieldStyle(.roundedBorder)
                            .padding(.leading)
                            .padding(.trailing)
                        if !authVm.password.isEmpty {
                            if authVm.password.count >= 6 {
                                RightView()
                            } else {
                                FalseView()
                            }
                        }
                    }
                }
                Spacer()
                VStack(alignment: .leading){
                    Text("Passwort wiederholen")
                        .font(.system(size: 10))
                        .foregroundColor(.primary)
                        .padding(.leading)
                    ZStack(alignment: .trailing){
                        SecureField("Passwort wiederholen", text: $authVm.confirmPassword)
                            .textFieldStyle(.roundedBorder)
                            .padding(.leading)
                            .padding(.trailing)
                        if (!authVm.confirmPassword.isEmpty) {
                            if  (authVm.password == authVm.confirmPassword) {
                                RightView()
                            } else {
                                FalseView()
                            }
                        }
                    }
                }
                Spacer()
                    .padding()
                    ButtonTextAction(iconName: "paperplane.fill", text: "Registrieren"){
                        if (!authVm.email.isEmpty) && (!authVm.userName.isEmpty) && (authVm.password == authVm.confirmPassword) && (!authVm.password.isEmpty) && (!authVm.confirmPassword.isEmpty){
                            authVm.register()
                        }
                    }
                    .alert(isPresented: $authVm.loginAlert){
                        Alert(title: Text("Hallo \(authVm.userName)"), message: Text("Deine Anmeldung war erfolgreich,\n du kannst dich jetzt einloggen"), dismissButton: .default(Text("OK"), action: {
                            showRegisterSheet.toggle()
                        }))
                    }
                    .alert(isPresented: $authVm.somethingGoneWrong){
                        Alert(title: Text("Hoppla \(authVm.userName)"), message: Text("Deine Anmeldung hat nicht geklappt"), dismissButton: .default(Text("OK")))
                    }
                Spacer()
            }
            .padding()
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
                    .ignoresSafeArea())
        }
    }
}

#Preview {
    RegisterView(showRegisterSheet: .constant(false))
        .environmentObject(AuthViewModel())
}
//-------------------------------------------------------------------------------------------------------------------------------------------

