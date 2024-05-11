//
//  Xtest.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 11.05.24.
//






//ProfileScreenView!!!!!

//
////
////  ProfileScreenView.swift
////  MeetMeAtTheCampfire
////
////  Created by Mike Reichenbach on 06.03.24.
////
//
//import SwiftUI
//
//struct ProfileScreenView: View {
//    @ObservedObject var profileScreenVm: ProfileScreenViewModel
//    @EnvironmentObject var authVm: AuthViewModel
//    @Environment(\.dismiss) private var dismiss
//    @AppStorage("homeLat") var homeBaseLatitude: Double = 49.849
//    @AppStorage("homeLong") var homeBaseLongitude: Double = 8.44
//    @State private var showHomeBaseAlert: Bool = false
//    @State private var latitude: String = ""
//    @State private var longitude: String = ""
//    @State private var showHomeBaseMapKit: Bool = false
//    @State var showSettingsSheet: Bool = false
//    @State private var showImagePicker: Bool = false
//    @State private var selectedImage: UIImage?
//
//    var body: some View {
//        let userName = authVm.user?.userName ?? "User unbekannt"
//        let userEmail = authVm.user?.email ?? "Email unbekannt"
//        // var userProfileImage = authVm.user?.imageUrl ?? ""
//        NavigationStack {
//            VStack {
//                Divider()
//                VStack{
//                    VStack{
//                        HStack(alignment: .top){
//                            VStack(alignment: .center){
//                                Button{
//                                    showImagePicker.toggle()
//                                } label: {
//                                    if authVm.selectedImage != nil {
//                                        ZStack{
//                                            Image(uiImage: authVm.selectedImage!)
//                                                .resizable()
//                                                .clipShape(Circle())
//                                                .scaledToFill()
//                                                .frame(width: 80, height: 80)
//                                                .overlay(
//                                                    Circle()
//                                                        .stroke(Color.cyan, lineWidth: 2))
//                                            Image(systemName: "dot.circle.and.hand.point.up.left.fill")
//                                                .font(.system(size: 35))
//                                                .offset(x: 35, y: -20)
//
////                                            if authVm.showSuccessTick {
////                                                Image(systemName: "checkmark.circle.fill")
////                                                    .foregroundColor(.green)
////                                                    .font(.system(size: 30))
////                                                    .transition(.scale)
////                                            }
//                                        }
//                                    } else {
//                                        AsyncImage(
//                                            url: URL(string: authVm.userProfileImage),
//                                            content: { image in
//                                                ZStack{
//                                                    image
//                                                        .resizable()
//                                                        .clipShape(Circle())
//                                                        .scaledToFill()
//                                                        .frame(width: 80, height: 80)
//                                                        .overlay(
//                                                            Circle()
//                                                                .stroke(Color.cyan, lineWidth: 2))
//                                                    Image(systemName: "dot.circle.and.hand.point.up.left.fill")
//                                                        .font(.system(size: 25))
//                                                        .offset(x: 35, y: -20)
//                                                }
//                                            },
//                                            placeholder: {
//                                                Image(systemName: "photo.badge.plus")
//                                                    .frame(width: 80,  height: 80)
//                                                    .font(.system(size: 40))
//                                                    .overlay(
//                                                        Circle()
//                                                            .stroke(Color.cyan, lineWidth: 2))
//                                            }
//                                        )
//                                    }
//                                }
//                                Button{
//                                    authVm.profileImageToStorage()
//                                    if !authVm.userProfileImage.isEmpty{
//                                        authVm.deleteProfileImage(imageUrl: authVm.userProfileImage)
//                                    }
//                                } label: {
//                                    Text("Speichern")
//                                        .font(.system(size: 14))
//                                        .bold()
//                                }
//                            }
//                            Spacer()
//                            VStack(alignment: .trailing){
//                                HStack{
//                                    Image(systemName: "mappin.and.ellipse")
//                                        .foregroundColor(.red)
//                                    Button("HomeBase Koordinaten"){
//                                        showHomeBaseAlert.toggle()
//                                    }
//                                    .alert("Homebase ändern,\nz.B 33.975", isPresented: $showHomeBaseAlert){
//
//                                        TextField("Latitude", text: $latitude)
//                                            .lineLimit(1)
//                                            .textInputAutocapitalization(.never)
//                                            .autocorrectionDisabled()
//                                        TextField("Longitude", text: $longitude)
//                                            .lineLimit(1)
//                                            .textInputAutocapitalization(.never)
//                                            .autocorrectionDisabled()
//                                        Button("Homebase auf Karte wählen"){
//                                            showHomeBaseMapKit.toggle()
//                                        }
//                                        Button("Zurück") {
//                                            dismiss()
//                                        }
//                                        Button("Speichern") {
//                                            homeBaseLatitude = Double(latitude) ?? 0.0
//                                            homeBaseLongitude = Double(longitude) ?? 0.0
//                                        }
//                                    }
//                                }
//                                Text("Latitude \(homeBaseLatitude)")
//                                    .font(.system(size: 13))
//                                Text("Longitude \(homeBaseLongitude)")
//                                    .font(.system(size: 13))
//                            }
//                            .padding(7)
//                            .background(Color.cyan.opacity(0.3))
//                            .cornerRadius(10)
//                        }
//                        .frame(width: 350)
//                        .padding(1)
//                        Spacer()
//                        HStack{
//                            Text(userName)
//                                .bold()
//                            Spacer()
//                            Text(userEmail)
//                        }
//                        .frame(width: 300, alignment: .leading)
//                        Spacer()
//                        HStack{
//                            Text("UserId: \(FirebaseManager.shared.userId ?? "no user Id")")
//                                .font(.caption)
//                        }
//                        .frame(width: 300, alignment: .leading)
//                    }
//                }
//                .frame(height: 170, alignment: .leading)
//                VStack{
//                    Divider()
//                        .background(.gray)
//                    Spacer()
//                    Text("Meine gespeicherten Nachrichten")
//                        .font(.headline)
//                        .bold()
//                        .italic()
//                        .frame(width: 300, alignment: .leading)
//                    ScrollView{
//                        ForEach(profileScreenVm.chatLikedViewModels){ chatLikedViewModel in
//                            ChatItemView(chatSenderVm: chatLikedViewModel)
//                                .id(chatLikedViewModel.id)
//                        }
//                    }
//                    .frame(width: 300, alignment: .center)
//                }
//                Divider()
//            }
//            .toolbar{
//                ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading){
//                    Button {
//                        showSettingsSheet.toggle()
//                    } label: {
//                        Image(systemName: "gearshape")
//                    }
//                }
//                ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing){
//                    Button {
//                        profileScreenVm.removeListener()
//                        authVm.logout()
//                    } label: {
//                        Text("Ausloggen")
//                        Image(systemName: "door.left.hand.open")
//                    }
//                }
//            }
//            .navigationBarTitle("Mein Profil", displayMode: .inline)
//            .background(
//                Image("background")
//                    .resizable()
//                    .scaledToFill()
//                    .opacity(0.2)
//                    .ignoresSafeArea(.all))
//        }
//        .sheet(isPresented: $showHomeBaseMapKit) {
//            HomeBaseSheetView(profileScreenVm: profileScreenVm)
//        }
//        .sheet(isPresented: $showSettingsSheet) {
//            SettingsScreenView()
//        }
//        .sheet(isPresented: $showImagePicker, onDismiss: nil) {
//            ImagePicker(selectedImage: $authVm.selectedImage, showImagePicker: $showImagePicker)
//        }
//        .onAppear{
//            profileScreenVm.readLikedMessages()
//        }
//        .onDisappear{
//            profileScreenVm.removeListener()
//        }
//        .background(Color(UIColor.systemBackground))
//    }
//}
//
//#Preview {
//    let profileScreenVm = ProfileScreenViewModel(user: UserModel(id: "", email: "", registeredTime: Date(), userName: "Hans", timeStampLastVisitChat: Date(), isActive: true, imageUrl: ""))
//    return ProfileScreenView(profileScreenVm: profileScreenVm, showSettingsSheet: false)
//        .environmentObject(AuthViewModel())
//}
//
//














//
////
////  AuthViewModel.swift
////  MeetMeAtTheCampfire
////
////  Created by Mike Reichenbach on 29.02.24.
////
//
//import Foundation
//import FirebaseAuth
//import FirebaseFirestore
//import SwiftUI
//
//class AuthViewModel: ObservableObject{
//    
//    //Öffentliche Variablen, die durch Nutzung des ViewModels auf den Screens bentuzt werden können
//    @Published var email: String = ""
//    @Published var password: String = ""
//    @Published var confirmPassword: String = ""
//    @Published var userName: String = ""
//    @Published var registerSuccessfullAlert: Bool = false
//    @Published var registerFailedAlert: Bool = false
//    @Published var showEmailSendAlert: Bool = false
//    @Published var showEmailNotSendAlert: Bool = false
//    @Published var loginFailedAlert: Bool = false
//    @Published var isActive: Bool = true
//    @Published var imageUrl: String = ""
//    @Published var selectedImage: UIImage?
//    @Published var userProfileImage: String = ""
//    @Published var showSuccessTick: Bool = false
//    //Erstellen eines User gemäß festgelegten UserModel
//    @Published var user: UserModel?
//    private var listener: ListenerRegistration? = nil
//    
//    //Erstellen einer LoggedIn Variablen die zuerst auf false steht und nach dem einloggen entsprechend geändert wird
//    var userLoggedIn: Bool {
//        self.user != nil
//    }
//    
//    init(){
//        checkLogStatus()
//    }
//    
//    func login(){
//        FirebaseManager.shared.authentication.signIn(withEmail: self.email, password: self.password){
//            authResult, error in
//            if let user = self.workWithAuthResult(authResult: authResult, error: error){
//                self.readAppUser(withId: user.uid)
//            }
//            else {
//                self.loginFailedAlert.toggle()
//            }
//        }
//    }
//    
//    func register(){
//        FirebaseManager.shared.authentication.createUser(withEmail: self.email, password: self.password){
//            authResult, error in
//            if let user = self.workWithAuthResult(authResult: authResult, error: error){
//                self.createUser(withId: user.uid, email: self.email, userName: self.userName, imageUrl: self.imageUrl)
//                if authResult?.user != nil {
//                    self.registerSuccessfullAlert.toggle()
//                }
//            } else {
//                self.registerFailedAlert.toggle()
//            }
//        }
//    }
//    
//    func logout(){
//            updateUser()
//            removeListener()
//            try? FirebaseManager.shared.authentication.signOut()
//            print("User wurde erfolgreich abgemeldet")
//    }
//    
//    func checkLogStatus(){
//        guard let currentUser = FirebaseManager.shared.authentication.currentUser else {
//            print("User not logged in")
//            return
//        }
//        self.readAppUser(withId: currentUser.uid)
//       // self.addListenerForUserProfileImage()
//    }
//    
//    func workWithAuthResult(authResult: AuthDataResult?, error: Error?) -> User? {
//        //Fehler beim Einloggen, gib nichts zurück
//        if let error {
//            print("Error signing in: \(error)")
//            return nil
//        }
//        //Prüfe ob es ein authResult gibt, ansonsten gib nichts zurück
//        guard let authResult else {
//            print("authResult is empty")
//            return nil
//        }
//        //Wenn alles geklappt hat gib einen User zurück
//        return authResult.user
//        
//        
//    }
//    
//    func readAppUser(withId id: String){
//        self.listener = FirebaseManager.shared.firestore.collection("appUser").document(id).addSnapshotListener { documentSnapshot, error in
//            guard let document = documentSnapshot else {
//                print("Error fetching document: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//            
//            guard let appUser = try? document.data(as: UserModel.self) else {
//                print("Document does not exist or could not be decoded")
//                return
//            }
//            
//            DispatchQueue.main.async {
//                self.user = appUser
//                self.userProfileImage = appUser.imageUrl
//            }
//        }
//    }
//    
//    
//    //    func readAppUser(withId id: String){
//    //        FirebaseManager.shared.firestore.collection("appUser").document(id).getDocument{
//    //            document, error in
//    //            if let error {
//    //                print("Error reading appUser with id \(error)")
//    //                return
//    //            }
//    //
//    //            guard let document else {
//    //                print("Document is empty \(id)")
//    //                return
//    //            }
//    //
//    //            do{
//    //                //hier wird das UserModel decodiert und der User gelesen
//    //                let appUser = try document.data(as: UserModel.self)
//    //                self.user = appUser
//    //            } catch {
//    //                print("Decoding appUser failed with error \(error)")
//    //            }
//    //        }
//    //    }
//    //
//    func createUser(withId id: String, email: String, userName: String, imageUrl: String){
//        //Kreire einen neuen appUser gemäß UserModel
//        let appUser = UserModel(id: id, email: email, registeredTime: Date(), userName: userName, timeStampLastVisitChat: Date.now, isActive: isActive, imageUrl: imageUrl)
//        do{
//            //Gehe in den Firestore, erstelle dort eine Col. appUser mit doc id und den Daten gemäß UserModel
//            try FirebaseManager.shared.firestore.collection("appUser").document(id).setData(from: appUser)
//        } catch {
//            print("Could not create new appUser: \(error)")
//        }
//    }
//    
//    //Hier wird nur der timeStamp für den letzen ChatBesuch aktualisiert
//    func updateUser(){
//        
//        guard var currentUser = user else {
//            return
//        }
//        
//        guard let currentUserId = FirebaseManager.shared.userId else {
//            return
//        }
//        
//        currentUser.timeStampLastVisitChat = Date.now
//        
//        do{
//            try FirebaseManager.shared.firestore.collection("appUser").document(currentUserId).setData(from: currentUser)
//            print("Update appUser succeeded")
//        } catch {
//            print("Could not update appUser: \(error)")
//        }
//    }
//    
//    //Reset Password and send email with reset and get a new one
//    func passwordSendWithEmail(email: String, completion: @escaping (Error?) -> Void) {
//        Auth.auth().sendPasswordReset(withEmail: email) { error in
//            if let error = error {
//                completion(error)
//                self.showEmailNotSendAlert.toggle()
//            } else {
//                // Erfolgreiches Zurücksetzen des Passworts
//                completion(nil)
//                self.showEmailSendAlert.toggle()
//            }
//        }
//    }
//    
//    @MainActor
//    func deleteAccount(completion: @escaping () -> Void) {
//        guard let currentUserId = FirebaseManager.shared.authentication.currentUser else {
//            return
//        }
//        
//        currentUserId.delete(){ error in
//            if error == nil {
//                completion()
//            }
//        }
//    }
//    
//    @MainActor
//    func deleteUserData(completion: @escaping () -> Void) {
//        
//        guard let currentUser = FirebaseManager.shared.userId else {
//            return
//        }
//        
//        FirebaseManager.shared.firestore.collection("appUser")
//            .document(currentUser).delete(){ error in
//                if error == nil {
//                    completion()
//                }
//            }
//    }
//    //  --------------------------------------------
//    func profileImageToStorage() {
//        guard let uploadProfileImage = selectedImage,
//              let imageData = uploadProfileImage.jpegData(compressionQuality: 0.6) else {
//            return
//        }
//        
//        let fileRef = FirebaseManager.shared.storage.reference().child("/profile/\(UUID().uuidString).jpg")
//        
//        fileRef.putData(imageData, metadata: nil) { metadata, error in
//            guard error == nil, let _ = metadata else {
//                print("Error loading metadata profileImage \(error ?? NSError())")
//                return
//            }
//            
//            fileRef.downloadURL { url, error in
//                guard let imageUrl = url?.absoluteString else {
//                    print("Bad url request")
//                    return
//                }
//                self.updateProfileImageToFirestore(imageUrl: imageUrl)
//                // Anzeige des Erfolgshäkchens
//                withAnimation {
//                    self.showSuccessTick = true
//                }
//                // Nach 2 Sekunden die Anzeige des Erfolgshäkchens zurücksetzen
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                    withAnimation {
//                        self.showSuccessTick = false
//                    }
//                }
//            }
//        }
//    }
//    
//    private func updateProfileImageToFirestore(imageUrl: String){
//        guard var currentUser = user else {
//            return
//        }
//        
//        guard let currentUserId = FirebaseManager.shared.userId else {
//            return
//        }
//        
//        currentUser.imageUrl = imageUrl
//        
//        do {
//            try FirebaseManager.shared.firestore.collection("appUser")
//                .document(currentUserId).setData(from: currentUser)
//            print("Updating profileImage successfull")
//        } catch {
//            print("Error updating profileImage: \(error)")
//        }
//    }
//    
//    func deleteProfileImage(imageUrl: String) {
//        let imageRef = FirebaseManager.shared.storage.reference(forURL: imageUrl)
//        
//        imageRef.delete() { error in
//            if let error = error {
//                print("Deleting profile image failed: \(error)")
//            } else {
//                print("Deleting profile image successful")
//            }
//        }
//    }
//    
//    //    func addListenerForUserProfileImage() {
//    //        guard let userId = FirebaseManager.shared.userId else {
//    //            return
//    //        }
//    //
//    //        FirebaseManager.shared.firestore.collection("appUser").document(userId)
//    //            .addSnapshotListener { documentSnapshot, error in
//    //                guard let document = documentSnapshot else {
//    //                    print("Error fetching document")
//    //                    return
//    //                }
//    //
//    //                guard let userData = try? document.data(as: UserModel.self) else {
//    //                    print("Document does not exist")
//    //                    return
//    //                }
//    //
//    //                DispatchQueue.main.async {
//    //                    self.userProfileImage = userData.imageUrl
//    //                }
//    //            }
//    //    }
//    
//    func removeListener(){
//        self.userName = ""
//        self.email = ""
//        self.password = ""
//        self.confirmPassword = ""
//        self.imageUrl = ""
//        self.userProfileImage = ""
//        self.listener = nil
//        self.user = nil
//    }
//}


//
//import Foundation
//import FirebaseFirestore
//import FirebaseAuth
//import SwiftUI
//
//class AuthViewModel: ObservableObject{
//
//    //Öffentliche Variablen, die durch Nutzung des ViewModels auf den Screens bentuzt werden können
//    @Published var email: String = ""
//    @Published var password: String = ""
//    @Published var confirmPassword: String = ""
//    @Published var userName: String = ""
//    @Published var registerSuccessfullAlert: Bool = false
//    @Published var registerFailedAlert: Bool = false
//    @Published var showEmailSendAlert: Bool = false
//    @Published var showEmailNotSendAlert: Bool = false
//    @Published var loginFailedAlert: Bool = false
//    @Published var isActive: Bool = true
//    @Published var imageUrl: String = ""
//    @Published var selectedImage: UIImage?
//    @Published var userProfileImage: String = ""
//    @Published var showSuccessTick: Bool = false
//    //Erstellen eines User gemäß festgelegten UserModel
//    @Published var user: UserModel?
//
//    //Erstellen einer LoggedIn Variablen die zuerst auf false steht und nach dem einloggen entsprechend geändert wird
//    var userLoggedIn: Bool {
//        self.user != nil
//    }
//
//    init(){
//        checkLogStatus()
//    }
//
//    func login(){
//        FirebaseManager.shared.authentication.signIn(withEmail: self.email, password: self.password){
//            authResult, error in
//            if let user = self.workWithAuthResult(authResult: authResult, error: error){
//                self.readAppUser(withId: user.uid)
//            }
//            else {
//                self.loginFailedAlert.toggle()
//            }
//        }
//    }
//
//    func register(){
//        FirebaseManager.shared.authentication.createUser(withEmail: self.email, password: self.password){
//            authResult, error in
//            if let user = self.workWithAuthResult(authResult: authResult, error: error){
//                self.createUser(withId: user.uid, email: self.email, userName: self.userName, imageUrl: self.imageUrl)
//                if authResult?.user != nil {
//                    self.registerSuccessfullAlert.toggle()
//                }
//            } else {
//                self.registerFailedAlert.toggle()
//            }
//        }
//    }
//
//    func logout(){
//        do{
//            updateUser()
//            self.user = nil
//            removeListener()
//            try FirebaseManager.shared.authentication.signOut()
//            print("User wurde erfolgreich abgemeldet")
//        } catch {
//            print("Error signing out \(error)")
//        }
//    }
//
//    func checkLogStatus(){
//        guard let currentUser = FirebaseManager.shared.authentication.currentUser else {
//            print("User not logged in")
//            return
//        }
//        self.readAppUser(withId: currentUser.uid)
//    }
//
//    func workWithAuthResult(authResult: AuthDataResult?, error: Error?) -> User? {
//        //Fehler beim Einloggen, gib nichts zurück
//        if let error {
//            print("Error signing in: \(error)")
//            return nil
//        }
//        //Prüfe ob es ein authResult gibt, ansonsten gib nichts zurück
//        guard let authResult else {
//            print("authResult is empty")
//            return nil
//        }
//        //Wenn alles geklappt hat gib einen User zurück
//        return authResult.user
//    }
//
//    func readAppUser(withId id: String){
//        FirebaseManager.shared.firestore.collection("appUser").document(id).addSnapshotListener { documentSnapshot, error in
//            guard let document = documentSnapshot else {
//                print("Error fetching document: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//
//            guard let appUser = try? document.data(as: UserModel.self) else {
//                print("Document does not exist or could not be decoded")
//                return
//            }
//
//            DispatchQueue.main.async {
//                self.user = appUser
//                self.userProfileImage = appUser.imageUrl
//            }
//        }
//    }
//
//    //    func readAppUser(withId id: String){
//    //        FirebaseManager.shared.firestore.collection("appUser").document(id).getDocument{
//    //            document, error in
//    //            if let error {
//    //                print("Error reading appUser with id \(error)")
//    //                return
//    //            }
//    //
//    //            guard let document else {
//    //                print("Document is empty \(id)")
//    //                return
//    //            }
//    //
//    //            do{
//    //                //hier wird das UserModel decodiert und der User gelesen
//    //                let appUser = try document.data(as: UserModel.self)
//    //                self.user = appUser
//    //            } catch {
//    //                print("Decoding appUser failed with error \(error)")
//    //            }
//    //        }
//    //    }
//
//    func createUser(withId id: String, email: String, userName: String, imageUrl: String){
//        //Kreire einen neuen appUser gemäß UserModel
//        let appUser = UserModel(id: id, email: email, registeredTime: Date(), userName: userName, timeStampLastVisitChat: Date.now, isActive: isActive, imageUrl: imageUrl)
//        do{
//            //Gehe in den Firestore, erstelle dort eine Col. appUser mit doc id und den Daten gemäß UserModel
//            try FirebaseManager.shared.firestore.collection("appUser").document(id).setData(from: appUser)
//        } catch {
//            print("Could not create new appUser: \(error)")
//        }
//    }
//
//    //Hier wird nur der timeStamp für den letzen ChatBesuch aktualisiert
//    func updateUser(){
//
//        guard var currentUser = user else {
//            return
//        }
//
//        guard let currentUserId = FirebaseManager.shared.userId else {
//            return
//        }
//
//        currentUser.timeStampLastVisitChat = Date.now
//
//        do{
//            try FirebaseManager.shared.firestore.collection("appUser").document(currentUserId).setData(from: currentUser)
//            print("Update appUser succeeded")
//        } catch {
//            print("Could not update appUser: \(error)")
//        }
//    }
//
//    //Reset Password and send email with reset and get a new one
//    func passwordSendWithEmail(email: String, completion: @escaping (Error?) -> Void) {
//        Auth.auth().sendPasswordReset(withEmail: email) { error in
//            if let error = error {
//                completion(error)
//                self.showEmailNotSendAlert.toggle()
//            } else {
//                // Erfolgreiches Zurücksetzen des Passworts
//                completion(nil)
//                self.showEmailSendAlert.toggle()
//            }
//        }
//    }
//
//    @MainActor
//    func deleteAccount(completion: @escaping () -> Void) {
//        guard let currentUserId = FirebaseManager.shared.authentication.currentUser else {
//            return
//        }
//
//        currentUserId.delete(){ error in
//            if error == nil {
//                completion()
//            }
//        }
//    }
//
//    @MainActor
//    func deleteUserData(completion: @escaping () -> Void) {
//
//        guard let currentUser = FirebaseManager.shared.userId else {
//            return
//        }
//
//        FirebaseManager.shared.firestore.collection("appUser")
//            .document(currentUser).delete(){ error in
//                if error == nil {
//                    completion()
//                }
//            }
//    }
//
//    func profileImageToStorage() {
//        guard let uploadProfileImage = selectedImage,
//              let imageData = uploadProfileImage.jpegData(compressionQuality: 0.6) else {
//            return
//        }
//
//        let fileRef = FirebaseManager.shared.storage.reference().child("/profile/\(UUID().uuidString).jpg")
//
//        fileRef.putData(imageData, metadata: nil) { metadata, error in
//            guard error == nil, let _ = metadata else {
//                print("Error loading metadata profileImage \(error ?? NSError())")
//                return
//            }
//
//            fileRef.downloadURL { url, error in
//                guard let imageUrl = url?.absoluteString else {
//                    print("Bad url request")
//                    return
//                }
//                self.updateProfileImageToFirestore(imageUrl: imageUrl)
//                // Anzeige des Erfolgshäkchens
//                withAnimation {
//                    self.showSuccessTick = true
//                }
//                // Nach 2 Sekunden die Anzeige des Erfolgshäkchens zurücksetzen
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                    withAnimation {
//                        self.showSuccessTick = false
//                    }
//                }
//            }
//        }
//    }
//
//    private func updateProfileImageToFirestore(imageUrl: String){
//        guard var currentUser = user else {
//            return
//        }
//
//        guard let currentUserId = FirebaseManager.shared.userId else {
//            return
//        }
//
//        currentUser.imageUrl = imageUrl
//
//        do {
//            try FirebaseManager.shared.firestore.collection("appUser")
//                .document(currentUserId).setData(from: currentUser)
//            print("Updating profileImage successfull")
//        } catch {
//            print("Error updating profileImage: \(error)")
//        }
//    }
//
//    func deleteProfileImage(imageUrl: String) {
//        let imageRef = FirebaseManager.shared.storage.reference(forURL: imageUrl)
//
//        imageRef.delete() { error in
//            if let error = error {
//                print("Deleting profile image failed: \(error)")
//            } else {
//                print("Deleting profile image successful")
//            }
//        }
//    }
//
//    func removeListener(){
//        email = ""
//        password = ""
//        confirmPassword = ""
//        userName = ""
////        imageUrl = ""
////        userProfileImage = ""
//    }
//}











































//import Foundation
//import FirebaseFirestore
//import FirebaseAuth
//import SwiftUI
//
//class AuthViewModel: ObservableObject{
//    
//    //Öffentliche Variablen, die durch Nutzung des ViewModels auf den Screens bentuzt werden können
//    @Published var email: String = ""
//    @Published var password: String = ""
//    @Published var confirmPassword: String = ""
//    @Published var userName: String = ""
//    @Published var registerSuccessfullAlert: Bool = false
//    @Published var registerFailedAlert: Bool = false
//    @Published var showEmailSendAlert: Bool = false
//    @Published var showEmailNotSendAlert: Bool = false
//    @Published var loginFailedAlert: Bool = false
//    @Published var isActive: Bool = true
//    @Published var imageUrl: String = ""
//    @Published var selectedImage: UIImage?
//    @Published var userProfileImage: String = ""
//    @Published var showSuccessTick: Bool = false
//    //Erstellen eines User gemäß festgelegten UserModel
//    @Published var user: UserModel?
//    
//    //Erstellen einer LoggedIn Variablen die zuerst auf false steht und nach dem einloggen entsprechend geändert wird
//    var userLoggedIn: Bool {
//        self.user != nil
//    }
//    
//    init(){
//        checkLogStatus()
//    }
//    
//    func login(){
//        FirebaseManager.shared.authentication.signIn(withEmail: self.email, password: self.password){
//            authResult, error in
//            if let user = self.workWithAuthResult(authResult: authResult, error: error){
//                self.readAppUser(withId: user.uid)
//            }
//            else {
//                self.loginFailedAlert.toggle()
//            }
//        }
//    }
//    
//    func register(){
//        FirebaseManager.shared.authentication.createUser(withEmail: self.email, password: self.password){
//            authResult, error in
//            if let user = self.workWithAuthResult(authResult: authResult, error: error){
//                self.createUser(withId: user.uid, email: self.email, userName: self.userName, imageUrl: self.imageUrl)
//                if authResult?.user != nil {
//                    self.registerSuccessfullAlert.toggle()
//                }
//            } else {
//                self.registerFailedAlert.toggle()
//            }
//        }
//    }
//    
//    func logout(){
//        do{
//            updateUser()
//            self.user = nil
//            removeListener()
//            try FirebaseManager.shared.authentication.signOut()
//            print("User wurde erfolgreich abgemeldet")
//        } catch {
//            print("Error signing out \(error)")
//        }
//    }
//    
//    func checkLogStatus(){
//        guard let currentUser = FirebaseManager.shared.authentication.currentUser else {
//            print("User not logged in")
//            return
//        }
//        self.readAppUser(withId: currentUser.uid)
//    }
//    
//    func workWithAuthResult(authResult: AuthDataResult?, error: Error?) -> User? {
//        //Fehler beim Einloggen, gib nichts zurück
//        if let error {
//            print("Error signing in: \(error)")
//            return nil
//        }
//        //Prüfe ob es ein authResult gibt, ansonsten gib nichts zurück
//        guard let authResult else {
//            print("authResult is empty")
//            return nil
//        }
//        //Wenn alles geklappt hat gib einen User zurück
//        return authResult.user
//    }
//    
//    func readAppUser(withId id: String){
//        FirebaseManager.shared.firestore.collection("appUser").document(id).addSnapshotListener { documentSnapshot, error in
//            guard let document = documentSnapshot else {
//                print("Error fetching document: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//            
//            guard let appUser = try? document.data(as: UserModel.self) else {
//                print("Document does not exist or could not be decoded")
//                return
//            }
//            
//            DispatchQueue.main.async {
//                self.user = appUser
//                self.userProfileImage = appUser.imageUrl
//            }
//        }
//    }
//    
//    //    func readAppUser(withId id: String){
//    //        FirebaseManager.shared.firestore.collection("appUser").document(id).getDocument{
//    //            document, error in
//    //            if let error {
//    //                print("Error reading appUser with id \(error)")
//    //                return
//    //            }
//    //
//    //            guard let document else {
//    //                print("Document is empty \(id)")
//    //                return
//    //            }
//    //
//    //            do{
//    //                //hier wird das UserModel decodiert und der User gelesen
//    //                let appUser = try document.data(as: UserModel.self)
//    //                self.user = appUser
//    //            } catch {
//    //                print("Decoding appUser failed with error \(error)")
//    //            }
//    //        }
//    //    }
//    
//    func createUser(withId id: String, email: String, userName: String, imageUrl: String){
//        //Kreire einen neuen appUser gemäß UserModel
//        let appUser = UserModel(id: id, email: email, registeredTime: Date(), userName: userName, timeStampLastVisitChat: Date.now, isActive: isActive, imageUrl: imageUrl)
//        do{
//            //Gehe in den Firestore, erstelle dort eine Col. appUser mit doc id und den Daten gemäß UserModel
//            try FirebaseManager.shared.firestore.collection("appUser").document(id).setData(from: appUser)
//        } catch {
//            print("Could not create new appUser: \(error)")
//        }
//    }
//    
//    //Hier wird nur der timeStamp für den letzen ChatBesuch aktualisiert
//    func updateUser(){
//        
//        guard var currentUser = user else {
//            return
//        }
//        
//        guard let currentUserId = FirebaseManager.shared.userId else {
//            return
//        }
//        
//        currentUser.timeStampLastVisitChat = Date.now
//        
//        do{
//            try FirebaseManager.shared.firestore.collection("appUser").document(currentUserId).setData(from: currentUser)
//            print("Update appUser succeeded")
//        } catch {
//            print("Could not update appUser: \(error)")
//        }
//    }
//    
//    //Reset Password and send email with reset and get a new one
//    func passwordSendWithEmail(email: String, completion: @escaping (Error?) -> Void) {
//        Auth.auth().sendPasswordReset(withEmail: email) { error in
//            if let error = error {
//                completion(error)
//                self.showEmailNotSendAlert.toggle()
//            } else {
//                // Erfolgreiches Zurücksetzen des Passworts
//                completion(nil)
//                self.showEmailSendAlert.toggle()
//            }
//        }
//    }
//    
//    @MainActor
//    func deleteAccount(completion: @escaping () -> Void) {
//        guard let currentUserId = FirebaseManager.shared.authentication.currentUser else {
//            return
//        }
//        
//        currentUserId.delete(){ error in
//            if error == nil {
//                completion()
//            }
//        }
//    }
//    
//    @MainActor
//    func deleteUserData(completion: @escaping () -> Void) {
//        
//        guard let currentUser = FirebaseManager.shared.userId else {
//            return
//        }
//        
//        FirebaseManager.shared.firestore.collection("appUser")
//            .document(currentUser).delete(){ error in
//                if error == nil {
//                    completion()
//                }
//            }
//    }
//    
//    func profileImageToStorage() {
//        guard let uploadProfileImage = selectedImage,
//              let imageData = uploadProfileImage.jpegData(compressionQuality: 0.6) else {
//            return
//        }
//        
//        let fileRef = FirebaseManager.shared.storage.reference().child("/profile/\(UUID().uuidString).jpg")
//        
//        fileRef.putData(imageData, metadata: nil) { metadata, error in
//            guard error == nil, let _ = metadata else {
//                print("Error loading metadata profileImage \(error ?? NSError())")
//                return
//            }
//            
//            fileRef.downloadURL { url, error in
//                guard let imageUrl = url?.absoluteString else {
//                    print("Bad url request")
//                    return
//                }
//                self.updateProfileImageToFirestore(imageUrl: imageUrl)
//                // Anzeige des Erfolgshäkchens
//                withAnimation {
//                    self.showSuccessTick = true
//                }
//                // Nach 2 Sekunden die Anzeige des Erfolgshäkchens zurücksetzen
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                    withAnimation {
//                        self.showSuccessTick = false
//                    }
//                }
//            }
//        }
//    }
//    
//    private func updateProfileImageToFirestore(imageUrl: String){
//        guard var currentUser = user else {
//            return
//        }
//        
//        guard let currentUserId = FirebaseManager.shared.userId else {
//            return
//        }
//        
//        currentUser.imageUrl = imageUrl
//        
//        do {
//            try FirebaseManager.shared.firestore.collection("appUser")
//                .document(currentUserId).setData(from: currentUser)
//            print("Updating profileImage successfull")
//        } catch {
//            print("Error updating profileImage: \(error)")
//        }
//    }
//    
//    func deleteProfileImage(imageUrl: String) {
//        let imageRef = FirebaseManager.shared.storage.reference(forURL: imageUrl)
//        
//        imageRef.delete() { error in
//            if let error = error {
//                print("Deleting profile image failed: \(error)")
//            } else {
//                print("Deleting profile image successful")
//            }
//        }
//    }
//    
//    func removeListener(){
//        email = ""
//        password = ""
//        confirmPassword = ""
//        userName = ""
////        imageUrl = ""
////        userProfileImage = ""
//    }
//}
//






























//
//import SwiftUI
//
//struct HomeScreenView: View {
//    @StateObject private var homeVm = HomeScreenViewModel()
//    @StateObject private var detailCategorieVm = DetailCategorieViewModel()
//    @StateObject private var detailCategorieItemVm = DetailCategorieItemViewModel(detailCategorieItemModel: TaskModel(categorieId: "1", taskName: "1", taskIsDone: false))
//    @State private var showAnimation: Bool = false
//    @State private var showNewCategorieAlert: Bool = false
//    @State private var newCategorie: String = ""
//    @State private var showSettingsSheet: Bool = false
//    @Environment(\.dismiss) private var dismiss
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                Divider()
//                VStack{
//                    ScrollView {
//                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 3), spacing: 20) {
//                            ForEach(homeVm.categorieViewModels) { categorieViewModel in
//                                NavigationLink(destination: DetailCategorieView(categorieVm: categorieViewModel, homeVm: homeVm, detailCategorieVm: detailCategorieVm, detailCategorieItemVm: detailCategorieItemVm)) {
//                                    CategorieFilledView(categorieVm: categorieViewModel, detailCategorieVm: detailCategorieVm)
//                                }
//                            }
//                        }
//                        .padding(.horizontal, 20)
//                    }
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .padding(.vertical, 20)
//                }
//                VStack{
//                    ZStack{
//                        if homeVm.categorieViewModels.isEmpty {
//                            ZStack{
//                                    Image(.logo)
//                                        .resizable()
//                                        .shadow(color: Color.cyan, radius: 4)
//                                        .frame(width: 140, height: 200)
//                                        .clipShape(Circle())
//                                        .opacity(0.7)
//                                RoundedView(title: "   Deine Camper App -Meet me at the campfire".uppercased(), radius: 140)
//                            }
//                            .offset(x: 0, y: -300)
//                        }
//                        VStack{
//                            if homeVm.categorieViewModels.isEmpty {
//                                Image(.cat)
//                                    .resizable()
//                                    .scaledToFill()
//                                    .opacity(0.7)
//                                    .frame(width: 250)
//                                    .cornerRadius(10)
//                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
//                            }
//                        }
//                    }
//                    VStack{
//                        if !homeVm.categorieViewModels.isEmpty && homeVm.categorieViewModels[0].tasksInCategorie == 0  {
//                            GeometryReader { geometry in
//                                Image(.todo)
//                                    .resizable()
//                                    .scaledToFill()
//                                    .opacity(0.7)
//                                    .frame(width: min(geometry.size.width - 20, 250))
//                                    .cornerRadius(10)
//                                    .offset(
//                                        x: min(geometry.size.width / 5 - 0, 30),
//                                        y: min(geometry.size.height / 5 - 185, 0))
//                            }
//                        }
//                    }
//                }
//                Button{
//                    showNewCategorieAlert.toggle()
//                }label: {
//                    CategorieAddView()
//                }
//                .animation(Animation.smooth(duration: 0.9, extraBounce: 0.6), value: showAnimation)
//                .onAppear {
//                    showAnimation = true
//                }
//                Divider()
//            }
//            .toolbar{
//                Button {
//                    showSettingsSheet.toggle()
//                } label: {
//                    Image(systemName: "gearshape")
//                }
//            }
//            .background(
//                Image("background")
//                    .resizable()
//                    .scaledToFill()
//                    .opacity(0.2)
//                    .ignoresSafeArea(.all))
//            .navigationBarTitle("Meine Kategorien", displayMode: .inline)
//        }
//        .alert("Neue Kategorie", isPresented: $showNewCategorieAlert) {
//                TextField("Name", text: $newCategorie)
//                    .lineLimit(1)
//                    .autocorrectionDisabled()
//                Button("Zurück") {
//                    newCategorie = ""
//                    dismiss()
//                }
//                Button("Speichern") {
//                    homeVm.createCategorie(categorieName: newCategorie)
//                    newCategorie = ""
//                }
//        }
//        .sheet(isPresented: $showSettingsSheet) {
//            SettingsScreenView()
//        }
//        .onAppear {
//            homeVm.readCategories()
//        }
//        .onDisappear{
//            homeVm.removeListener()
//            showAnimation = false
//        }
//        .background(Color(UIColor.systemBackground))
//    }
//}
//
//#Preview {
//    HomeScreenView()
//}
