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
                    VStack(alignment: .leading){
                        Text("Email")
                            .font(.system(size: 10))
                        TextField("Email eingeben", text: $emailForPasswortSending)
                            .font(.system(size: 15).bold())
                            .textFieldStyle(.roundedBorder)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .padding(1)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.cyan, lineWidth: 2)
                            )
                    }
                    .padding(40)
                    Spacer()
                }
                .keyboardType(.emailAddress)
                .submitLabel(.done)
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
                    .alert(
                        isPresented: $authVm.showEmailSendAlert){
                        Alert(
                            title: Text("Email versendet"),
                            message: Text("Bitte schau in dein Postfach"),
                            dismissButton: .default(Text("OK")))
                    }
                }
                .padding(.bottom)
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
            Alert(
                title: Text("Hoppla!"),
                message: Text("Das hat leider nicht geklappt"),
                dismissButton: .default(Text("OK")))
        }
        .background(Color(UIColor.systemBackground))
    }
}

#Preview {
    PasswortSendWithEmailView(showPasswordWithEmail: .constant(false))
        .environmentObject(AuthViewModel())
}
