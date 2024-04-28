//
//  PasswortSendWithEmailView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 25.04.24.
//

import SwiftUI
struct PasswortSendWithEmailView: View {
    
    @EnvironmentObject private var authVm: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var showPasswordWithEmail: Bool
    @State private var emailForPasswortSending: String = ""
    
    var body: some View {
        NavigationStack{
            VStack{
                VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/){
                    Spacer()
                    Text("Hoppla! Passwort vergessen?")
                        .font(.callout)
                        .bold()
                    Text("Gib deine Email Adresse ein")
                        .font(.callout)
                        .bold()
                    TextField("Email eingeben", text: $emailForPasswortSending)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(40)
                    Spacer()
                }
                .keyboardType(.emailAddress)
                .submitLabel(.done)
                Divider()
                VStack{
                    ButtonTextAction(iconName: "paperplane.fill", text: "Abschicken"){
                        authVm.passwordSendWithEmail(email: emailForPasswortSending) { error in
                            if let error = error {
                                print("Password reset email failed: \(error).")
                            } else {
                                print("Password reset email sent successfully.")
                            }
                        }
                    }
                    .alert(isPresented: $authVm.showEmailSendAlert){
                        Alert(title: Text("Email versendet"), message: Text("Bitte schau in dein Postfach"), dismissButton: .default(Text("OK")))
                    }
                }
                .padding(.top)
            }
            .padding(20)
            .onDisappear{
                emailForPasswortSending = ""
            }
            .toolbar{
                Button("Abbrechen"){
                    dismiss()
                }
            }
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
                    .ignoresSafeArea(.all))
            .navigationTitle("Passwort vergessen")
            .navigationBarTitleDisplayMode(.inline)
        }
        .alert(isPresented: $authVm.showEmailNotSendAlert){
            Alert(title: Text("Hoppla!"), message: Text("Das hat leider nicht geklappt"), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    PasswortSendWithEmailView(showPasswordWithEmail: .constant(false))
        .environmentObject(AuthViewModel())
}
