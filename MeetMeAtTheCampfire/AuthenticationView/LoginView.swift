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
    
    var body: some View {
        VStack{
            
            Text("Camper Manager")
                .padding(4)
                .font(.headline)
                .italic()
                .bold()
                .foregroundStyle(.cyan)
                .background(Color.white.opacity(0.7))
                .cornerRadius(10)
            Image("logo")
                .resizable()
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .scaledToFit()
                .frame(width: 250, height: 250)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .padding()
            Text("Meet me at the campfire")
                .padding(8)
                .font(.title)
                .bold()
                .foregroundStyle(.cyan)
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white).opacity(0.7)
                .padding()
                .overlay(
                    VStack {
                            TextField("Email eingeben", text: $authVM.email)
                                .textFieldStyle(.roundedBorder)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .padding()
                        SecureField("Passwort eingeben", text: $authVM.password)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                        ButtonTextAction(iconName: "paperplane.fill", text: "Login"){
                            authVM.login()
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
                                    .presentationDetents([.medium, .large])
                            }
                        }
                    }
                        .padding()
                )
                .padding()
        }
        .background(
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea())
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
