//
//  AuthViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 29.02.24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class AuthViewModel: ObservableObject{
    
    //Öffentliche Variablen, die durch Nutzung des ViewModels auf den Screens bentuzt werden können
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var userName: String = ""
    @Published var loginAlert: Bool = false
    
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
            }
        }
    }
    
    func logout(){
        do{
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
        let appUser = UserModel(id: id, email: email, registeredTime: Date(), userName: userName)
        do{
            //Gehe in den Firestore, erstelle dort eine Col. appUser mit doc id und den Daten gemäß UserModel
            try FirebaseManager.shared.firestore.collection("appUser").document(id).setData(from: appUser)
        } catch {
            print("Could not create new appUser: \(error)")
        }
    }
}
