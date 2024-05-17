//
//  AuthViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 29.02.24.
//

import FirebaseFirestore
import SwiftUI
import FirebaseAuth

@MainActor
final class AuthViewModel: ObservableObject{
    
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
    
    private var listener: ListenerRegistration? = nil
    
    //Erstellen eines User gemäß festgelegten UserModel
    @Published var user: UserModel?
    
    //Überprüfung erfolgt in der @Main / Erstellen einer LoggedIn Variablen die zuerst auf false steht und nach dem einloggen entsprechend geändert wird
    var userLoggedIn: Bool {
        self.user != nil
    }
    
    init(){
        checkLogStatus()
    }
    
    //========================================================================================================================================================
    // Firebase Auth
    //========================================================================================================================================================
    
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
    
    func isValidUsername(_ username: String) -> Bool {
        guard username.count >= 10 else { return false }
        let trimmed = username.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty && !trimmed.allSatisfy { $0 == "." }
    }
    
    func logout(){
        do{
            updateUser()
            removeListener()
            try FirebaseManager.shared.authentication.signOut()
            self.user = nil
            print("User wurde erfolgreich abgemeldet")
        } catch {
            print("Error signing out \(error)")
        }
    }
    
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
    
    //========================================================================================================================================================
    // Firebase Firestore
    //========================================================================================================================================================
    
    func checkLogStatus(){
        guard let currentUser = FirebaseManager.shared.authentication.currentUser else {
            print("User not logged in")
            return
        }
        self.readAppUser(withId: currentUser.uid)
    }
    
    func createUser(withId id: String, email: String, userName: String, imageUrl: String){
        let appUser = UserModel(id: id, email: email, registeredTime: Date(), userName: userName, timeStampLastVisitChat: Date.now, isActive: isActive, imageUrl: imageUrl)
        do{
            try FirebaseManager.shared.firestore.collection("appUser").document(id).setData(from: appUser)
        } catch {
            print("Could not create new appUser: \(error)")
        }
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
                self.user?.imageUrl = appUser.imageUrl
            } catch {
                print("Decoding appUser failed with error \(error)")
            }
        }
    }
    
    func updateUser(){
        guard var currentUser = user else {
            return
        }
        guard let currentUserId = FirebaseManager.shared.userId else {
            return
        }
        currentUser.timeStampLastVisitChat = Date.now
        do{
            FirebaseManager.shared.firestore.collection("appUser").document(currentUserId).updateData(["timeStampLastVisitChat" : currentUser.timeStampLastVisitChat])
            print("Update timeStampLastVisitChat appUser done")
        }
    }
    
    private func updateProfileImageToFirestore(imageUrl: String){
        //User
        guard var currentUser = user else {
            return
        }
        //User Id
        guard let currentUserId = FirebaseManager.shared.userId else {
            return
        }
        //Ausgewählte Image Url
        currentUser.imageUrl = imageUrl
        //Image Url in die Collection schreiben
        do {
            FirebaseManager.shared.firestore.collection("appUser")
                .document(currentUserId).updateData(["imageUrl" : currentUser.imageUrl])
            print("Updating profileImage successfull")
        }
        //Ab hier update der chatMessages mit dem neuen Profilbild
        let messagesRef = FirebaseManager.shared.firestore.collection("messages")
        //Nachrichten die die userId enthalten finden
        let query = messagesRef.whereField("userId", isEqualTo: currentUserId)
        //Snapshot von allen gefundenen Nachrichten mit Fehlerbehandlung
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting for profileImage in chat documents: \(error)")
            } else {
                // Für jede gefundene Nachricht das ProfileImage aktualisieren
                for document in querySnapshot!.documents {
                    // Die ID des Dokuments
                    let documentID = document.documentID
                    // Das Dokument mit den neuen Daten aktualisieren
                    messagesRef.document(documentID).updateData(["profileImage": currentUser.imageUrl]) { error in
                        if let error = error {
                            print("Error updating profileImage in chat document: \(error)")
                        } else {
                            print("Document profileImage in chat successfully updated")
                        }
                    }
                }
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
            DispatchQueue.main.async {
                self.imageUrl = appUser.imageUrl
            }
        }
    }
    
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
    
    //========================================================================================================================================================
    // Firebase Storage
    //========================================================================================================================================================
    
    func profileImageToStorage() async {
        guard let uploadProfileImage = selectedImage else {
            return
        }
        
        let resizedImage = resizeImage(image: uploadProfileImage, targetSize: CGSize(width: 800, height: 800))
        
        let imageData = resizedImage.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            return
        }
        
        let fileRef = FirebaseManager.shared.storage.reference().child("/profile/\(UUID().uuidString).jpg")
        
        fileRef.putData(imageData!, metadata: nil) { metadata, error in
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
    
    //Helped by ChatGPT
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        // 1. Hole die ursprüngliche Größe des Bildes
        let size = image.size
        // 2. Berechne das Verhältnis der Zielbreite zur Originalbreite
        let widthRatio = targetSize.width / size.width
        // 3. Berechne das Verhältnis der Zielhöhe zur Originalhöhe
        let heightRatio = targetSize.height / size.height
        // 4. Deklariere eine Variable, um die neue Größe zu speichern
        var newSize: CGSize
        // 5. Wenn das Höhenverhältnis kleiner ist als das Breitenverhältnis
        if widthRatio > heightRatio {
            // 6. Berechne die neue Größe, wobei die Höhe maßgeblich ist und die Breite proportional angepasst wird
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            // 7. Berechne die neue Größe, wobei die Breite maßgeblich ist und die Höhe proportional angepasst wird
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        // 8. Erstelle ein Rechteck mit der neuen Größe, beginnend bei (0,0)
        let rect = CGRect(origin: .zero, size: newSize)
        // 9. Beginne einen neuen Bildkontext mit den Optionen, um ein neues Bild zu zeichnen
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        // 10. Zeichne das Bild in das Rechteck (dies skaliert das Bild)
        image.draw(in: rect)
        // 11. Hole das neu gezeichnete und skalierte Bild aus dem aktuellen Bildkontext
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // 12. Beende den Bildkontext
        UIGraphicsEndImageContext()
        // 13. Gib das neu erstellte Bild zurück
        return newImage!
    }

    
    func deleteProfileImage(imageUrl: String) async {
        guard var currentUser = user else {
            return
        }
        currentUser.imageUrl = imageUrl
        let profileImageRef = FirebaseManager.shared.storage.reference(forURL: currentUser.imageUrl)
        
        profileImageRef.delete() { error in
            if let error = error {
                print("Deleting profileImage failed \(error)")
            } else {
                print("Deleting profileImage successfull")
            }
        }
    }
    
    func removeListener(){
        self.password = ""
        self.confirmPassword = ""
        self.email = ""
        self.userName = ""
        self.imageUrl = ""
        self.selectedImage = nil
        self.listener = nil
    }
}

