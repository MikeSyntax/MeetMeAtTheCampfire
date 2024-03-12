//
//  RegisterView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 29.02.24.
//

import SwiftUI

struct RegisterView: View {
    
    @EnvironmentObject private var authVM: AuthViewModel
    //@Environment(\.dismiss) private var dismiss
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
                
                ZStack(alignment: .trailing){
                    TextField("Benutzernamen eingeben", text: $authVM.userName)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(.leading)
                        .padding(.trailing)
                    if !authVM.userName.isEmpty {
                        if authVM.userName.count >= 2 {
                            RightView()
                        } else {
                            FalseView()
                        }
                    }
                }
                
                ZStack(alignment: .trailing){
                    TextField("Email eingeben", text: $authVM.email)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(.leading)
                        .padding(.trailing)
                    if !authVM.email.isEmpty {
                        if authVM.email.count >= 2 {
                            RightView()
                        } else {
                            FalseView()
                        }
                    }
                }
                
                Divider()
                    .padding()
                
                ZStack(alignment: .trailing){
                    SecureField("Passwort eingeben", text: $authVM.password)
                        .textFieldStyle(.roundedBorder)
                        .padding(.leading)
                        .padding(.trailing)
                    if !authVM.password.isEmpty {
                        if authVM.password.count >= 6 {
                            RightView()
                        } else {
                            FalseView()
                        }
                    }
                }
                
                ZStack(alignment: .trailing){
                    SecureField("Passwort wiederholen", text: $authVM.confirmPassword)
                        .textFieldStyle(.roundedBorder)
                        .padding(.leading)
                        .padding(.trailing)
                    if (!authVM.confirmPassword.isEmpty) {
                        if  (authVM.password == authVM.confirmPassword) {
                            RightView()
                        } else {
                            FalseView()
                        }
                    }
                }
                
                Divider()
                    .padding()
                
                if (!authVM.email.isEmpty) && (!authVM.userName.isEmpty) && (authVM.password == authVM.confirmPassword) && (!authVM.password.isEmpty) && (!authVM.confirmPassword.isEmpty){
                    ButtonTextAction(iconName: "paperplane.fill", text: "Registrieren"){
                        authVM.register()
                        // showRegisterSheet.toggle()
                    }
                    .alert(isPresented: $authVM.loginAlert){
                        Alert(title: Text("Hallo \(authVM.userName)"), message: Text("Deine Anmeldung war erfolgreich,\n du kannst dich jetzt einloggen"), dismissButton: .default(Text("OK"), action: {
                            showRegisterSheet.toggle()
                        }))
                    }
                }
                Spacer()
            }
            .padding()
            .toolbar(content: {
                Button("zurück") {
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


