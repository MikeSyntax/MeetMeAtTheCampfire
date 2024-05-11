//
//  AuthViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 29.02.24.
//

import Foundation
import FirebaseFirestore
import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject{
    
    //Öffentliche Variablen, die durch Nutzung des ViewModels auf den Screens bentuzt werden können
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var userName: String = ""
    @Published var registerSuccessfullAlert: Bool = false
    @Published var registerFailedAlert: Bool = false
    @Published var showEmailSendAlert: Bool = false
    @Published var showEmailNotSendAlert: Bool = false
    @Published var loginFailedAlert: Bool = false
    @Published var isActive: Bool = true
    @Published var imageUrl: String = ""
    @Published var selectedImage: UIImage?
    @Published var showSuccessTick: Bool = false
    @Published var userProfileImage: String = ""
    private var listener: ListenerRegistration? = nil
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
                self.loginFailedAlert.toggle()
            }
        }
    }
    
    func register(){
        FirebaseManager.shared.authentication.createUser(withEmail: self.email, password: self.password){
            authResult, error in
            if let user = self.workWithAuthResult(authResult: authResult, error: error){
                self.createUser(withId: user.uid, email: self.email, userName: self.userName, imageUrl: self.imageUrl)
                if authResult?.user != nil {
                    self.registerSuccessfullAlert.toggle()
                }
            } else {
                self.registerFailedAlert.toggle()
            }
        }
    }
    
    func logout(){
        do{
            updateUser()
            removeListener()
            try FirebaseManager.shared.authentication.signOut()
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
        self.updateImageUrl(withId: currentUser.uid)
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
    
    func createUser(withId id: String, email: String, userName: String, imageUrl: String){
        //Kreire einen neuen appUser gemäß UserModel
        let appUser = UserModel(id: id, email: email, registeredTime: Date(), userName: userName, timeStampLastVisitChat: Date.now, isActive: isActive, imageUrl: imageUrl)
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
                self.showEmailNotSendAlert.toggle()
            } else {
                // Erfolgreiches Zurücksetzen des Passworts
                completion(nil)
                self.showEmailSendAlert.toggle()
            }
        }
    }
    
    @MainActor
    func deleteAccount(completion: @escaping () -> Void) {
        guard let currentUserId = FirebaseManager.shared.authentication.currentUser else {
            return
        }
        currentUserId.delete(){ error in
            if error == nil {
                completion()
            }
        }
    }
    
    @MainActor
    func deleteUserData(completion: @escaping () -> Void) {
        guard let currentUser = FirebaseManager.shared.userId else {
            return
        }
        FirebaseManager.shared.firestore.collection("appUser")
            .document(currentUser).delete(){ error in
                if error == nil {
                    completion()
                }
            }
    }
    
    func profileImageToStorage() {
        guard let uploadProfileImage = selectedImage,
              let imageData = uploadProfileImage.jpegData(compressionQuality: 0.6) else {
            return
        }
        
        let fileRef = FirebaseManager.shared.storage.reference().child("/profile/\(UUID().uuidString).jpg")
        
        fileRef.putData(imageData, metadata: nil) { metadata, error in
            guard error == nil, let _ = metadata else {
                print("Error loading metadata profileImage \(error ?? NSError())")
                return
            }
            fileRef.downloadURL { url, error in
                guard let imageUrl = url?.absoluteString else {
                    print("Bad url request")
                    return
                }
                self.updateProfileImageToFirestore(imageUrl: imageUrl)
                // Anzeige des Erfolgshäkchens
                withAnimation {
                    self.showSuccessTick = true
                }
                // Nach 2 Sekunden die Anzeige des Erfolgshäkchens zurücksetzen
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        self.showSuccessTick = false
                    }
                }
            }
        }
    }
    
    private func updateProfileImageToFirestore(imageUrl: String){
        guard var currentUser = user else {
            return
        }
        guard let currentUserId = FirebaseManager.shared.userId else {
            return
        }
        currentUser.imageUrl = imageUrl
        
        do {
            try FirebaseManager.shared.firestore.collection("appUser")
                .document(currentUserId).setData(from: currentUser)
            print("Updating profileImage successfull")
        } catch {
            print("Error updating profileImage: \(error)")
        }
    }
    
    func deleteProfileImage(imageUrl: String){
        let profileImageRef = FirebaseManager.shared.storage.reference(forURL: imageUrl)
        
        profileImageRef.delete() { error in
            if let error = error {
                print("Deleting profileImage failed \(error)")
            } else {
                print("Deleting profileImage successfull")
            }
        }
    }
    
    func updateImageUrl(withId id: String){
        self.listener = FirebaseManager.shared.firestore.collection("appUser").document(id).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            guard let appUser = try? document.data(as: UserModel.self) else {
                print("Document does not exist or could not be decoded")
                return
            }
           // DispatchQueue.main.async {
                self.imageUrl = appUser.imageUrl
                self.userProfileImage = self.imageUrl
       //     }
        }
    }
    
    func removeListener(){
        self.user = nil
        self.userName = ""
        self.email = ""
        self.password = ""
        self.confirmPassword = ""
        self.imageUrl = ""
        self.listener = nil
    }
}

//////ab hier angefangena und ailmmmer aksjiejsejs
///seislfjjsdlfsdjfjfj   sdkfj sdlf sdfkj
///


