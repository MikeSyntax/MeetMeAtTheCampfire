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
            Text("Login")
                .padding(4)
                .font(.largeTitle)
                .italic()
                .bold()
                .foregroundStyle(.gray)
            Image("logo")
                .resizable()
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .scaledToFit()
                .frame(width: 250, height: 250)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            Text("Meet me at the campfire")
                .padding(4)
                .font(.title)
                .bold()
                .foregroundStyle(.gray)
            Spacer()
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white).opacity(0.7)
                .padding(12)
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
                            //Todo Login Action
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
                            
                            // NavigationLink("Jetzt registrieren", destination: RegisterView())
                            //     .foregroundColor(.blue)
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
            //.opacity(0.2)
                .ignoresSafeArea())
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
