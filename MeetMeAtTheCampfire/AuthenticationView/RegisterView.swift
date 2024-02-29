//
//  RegisterView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 29.02.24.
//

import SwiftUI

struct RegisterView: View {
    
    @EnvironmentObject private var authVM: AuthViewModel
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
                    TextField("Email eingeben", text: $authVM.email)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
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
                            //Todo Login Action
                            showRegisterSheet.toggle()
                        }
                    } else {
                        Text("Leider stimmen die Passwörter nicht")
                    }
                    Spacer()
                }
                .padding()
                .toolbar(content: {
                    Button("Cancel") {
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


