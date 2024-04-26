//
//  AuthViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 29.02.24.
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject{
    
    //Öffentliche Variablen, die durch Nutzung des ViewModels auf den Screens bentuzt werden können
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var userName: String = ""
    @Published var loginAlert: Bool = false
    @Published var somethingGoneWrong: Bool = false
    @Published var showEmailSendAlert: Bool = false
    @Published var showEmailNotSendAlert: Bool = false
    
    //Erstellen eines User gemäß festgelegten UserModel
    @Published var user: UserModel?
    
    //Erstellen einer LoggedIn Variablen die zuerst auf false steht und nach dem einloggen entsprechend geändert wird
    var userLoggedIn: Bool {
        self.user != nil
    }
    
    init(){
        checkLogStatus()
    }
    
    func login(){
        FirebaseManager.shared.authentication.signIn(withEmail: self.email, password: self.password){
            authResult, error in
            if let user = self.workWithAuthResult(authResult: authResult, error: error){
                self.readAppUser(withId: user.uid)
            }
            else {
                self.somethingGoneWrong.toggle()
            }
        }
    }
    
    func register(){
        FirebaseManager.shared.authentication.createUser(withEmail: self.email, password: self.password){
            authResult, error in
            if let user = self.workWithAuthResult(authResult: authResult, error: error){
                self.createUser(withId: user.uid, email: self.email, userName: self.userName)
                if authResult?.user != nil {
                    self.loginAlert.toggle()
                }
            } else {
                self.somethingGoneWrong.toggle()
            }
        }
    }
    
    func logout(){
        do{
            updateUser()
            try FirebaseManager.shared.authentication.signOut()
            self.user = nil
            userName = ""
            email = ""
            password = ""
            confirmPassword = ""
            print("User wurde erfolgreich abgemeldet")
        } catch {
            print("Error signing out \(error)")
        }
    }
    
    func checkLogStatus(){
        guard let currentUser = FirebaseManager.shared.authentication.currentUser else {
            print("User not logged in")
            return
        }
        self.readAppUser(withId: currentUser.uid)
        
    }
    
    func workWithAuthResult(authResult: AuthDataResult?, error: Error?) -> User? {
        //Fehler beim Einloggen, gib nichts zurück
        if let error {
            print("Error signing in: \(error)")
            return nil
        }
        //Prüfe ob es ein authResult gibt, ansonsten gib nichts zurück
        guard let authResult else {
            print("authResult is empty")
            return nil
        }
        //Wenn alles geklappt hat gib einen User zurück
        return authResult.user
        
    }
    
    func readAppUser(withId id: String){
        FirebaseManager.shared.firestore.collection("appUser").document(id).getDocument{
            document, error in
            if let error {
                print("Error reading appUser with id \(error)")
                return
            }
            
            guard let document else {
                print("Document is empty \(id)")
                return
            }
            
            do{
                //hier wird das UserModel decodiert und der User gelesen
                let appUser = try document.data(as: UserModel.self)
                self.user = appUser
            } catch {
                print("Decoding appUser failed with error \(error)")
            }
        }
    }
    
    func createUser(withId id: String, email: String, userName: String){
        //Kreire einen neuen appUser gemäß UserModel
        let appUser = UserModel(id: id, email: email, registeredTime: Date(), userName: userName, timeStampLastVisitChat: Date.now)
        do{
            //Gehe in den Firestore, erstelle dort eine Col. appUser mit doc id und den Daten gemäß UserModel
            try FirebaseManager.shared.firestore.collection("appUser").document(id).setData(from: appUser)
        } catch {
            print("Could not create new appUser: \(error)")
        }
    }
    
    //Hier wird nur der timeStamp für den letzen ChatBesuch aktualisiert
    func updateUser(){
        
        guard var currentUser = user else {
            return
        }
        
        guard let currentUserId = FirebaseManager.shared.userId else {
            return
        }
        
        currentUser.timeStampLastVisitChat = Date.now
        
        do{
            try FirebaseManager.shared.firestore.collection("appUser").document(currentUserId).setData(from: currentUser)
            print("Update appUser succeeded")
        } catch {
            print("Could not update appUser: \(error)")
        }
    }
    
    //Reset Password and send email with reset and get a new one
    func passwordSendWithEmail(email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(error)
                self.showEmailNotSendAlert = true
            } else {
                // Erfolgreiches Zurücksetzen des Passworts
                completion(nil)
                self.showEmailSendAlert = true
            }
        }
    }

}

