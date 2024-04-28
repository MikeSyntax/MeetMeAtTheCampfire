//
//  LoginView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 29.02.24.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject private var authVm: AuthViewModel
    @State private var showRegisterSheet: Bool = false
    @State private var showPasswordWithEmail: Bool = false
    
    var body: some View {
        VStack{
            Spacer()
            VStack{
                ZStack{
                    Image(.logo)
                        .resizable()
                        .frame(width: 210, height: 210)
                        .clipShape(Circle())
                        .opacity(0.8)
                    CircularTextView(title: "   Deine Camper App -Meet me at the campfire".uppercased(), radius: 125)
                }
                VStack{
                    VStack{
                        Text("Meet me at the campfire")
                        Text("Der Weg ist das Ziel")
                    }
                    .frame(width: 210)
                    .padding(8)
                    .font(.headline)
                    .italic()
                    .bold()
                    .foregroundStyle(.cyan)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                }
                .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
            }
            Spacer()
            VStack {
                Spacer()
                VStack{
                    ZStack(alignment: .trailing){
                        TextField("Email eingeben", text: $authVm.email)
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding(EdgeInsets(top: 10, leading: 60, bottom: 10, trailing: 60))
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
                    Spacer()
                    ZStack(alignment: .trailing){
                        SecureField("Passwort eingeben", text: $authVm.password)
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding(EdgeInsets(top: 0, leading: 60, bottom: 10, trailing: 60))
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
                .keyboardType(.emailAddress)
                .submitLabel(.done)
                Spacer()
                ButtonTextAction(iconName: "paperplane.fill", text: "Login"){
                    if !authVm.password.isEmpty && authVm.password.count >= 6 {
                        authVm.login()
                    }
                }
                .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                .alert(isPresented: $authVm.loginFailedAlert){
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
            .frame(height: 320)
            .background(Color.white.opacity(0.8))
            .cornerRadius(10)
        }
        .scrollContentBackground(.hidden)
        .background(
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all))
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}

//class ChatLoginVC: UIViewController {
//    @IBOutlet weak var pinTF: UITextField!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupToolbar()
//    }
//    func setupToolbar(){
//        //Create a toolbar
//        let bar = UIToolbar()
//        //Create a done button with an action to trigger our function to dismiss the keyboard
//        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissMyKeyboard))
//        //Create a felxible space item so that we can add it around in toolbar to position our done button
//        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        //Add the created button items in the toobar
//        bar.items = [flexSpace, flexSpace, doneBtn]
//        bar.sizeToFit()
//        //Add the toolbar to our textfield
//        pinTF.inputAccessoryView = bar
//    }
//    @objc func dismissMyKeyboard(){
//        view.endEditing(true)
//    }
//}



//                .toolbar {
//                    ToolbarItemGroup(placement: .keyboard){
//                        Spacer()
//                        Button("Done"){
//                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                        }
//                    }
//                }
