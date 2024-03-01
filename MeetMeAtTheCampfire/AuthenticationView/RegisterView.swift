//
//  RegisterView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 29.02.24.
//

import SwiftUI

struct RegisterView: View {
    
    @EnvironmentObject private var authVM: AuthViewModel
    @Environment(\.dismiss) private var dismiss
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
                TextField("Benutzernamen eingeben", text: $authVM.userName)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(.leading)
                    .padding(.trailing)
                TextField("Email eingeben", text: $authVM.email)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(.leading)
                    .padding(.trailing)
                Divider()
                    .padding()
                SecureField("Passwort eingeben", text: $authVM.password)
                    .textFieldStyle(.roundedBorder)
                    .padding(.leading)
                    .padding(.trailing)
                SecureField("Passwort wiederholen", text: $authVM.confirmPassword)
                    .textFieldStyle(.roundedBorder)
                    .padding(.leading)
                    .padding(.trailing)
                Divider()
                    .padding()
                if authVM.password == authVM.confirmPassword {
                    ButtonTextAction(iconName: "paperplane.fill", text: "Registrieren"){
                        authVM.register()
                        showRegisterSheet.toggle()
                    }
                }
                Spacer()
            }
            .padding()
            .toolbar(content: {
                Button("zurück") {
                    showRegisterSheet.toggle()
                }
                .alert(isPresented: $authVM.loginAlert){
                    Alert(title: Text("Hallo \(authVM.userName)"), message: Text("Deine Anmeldung war erfolgreich,\n du kannst dich jetzt einloggen"))
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


