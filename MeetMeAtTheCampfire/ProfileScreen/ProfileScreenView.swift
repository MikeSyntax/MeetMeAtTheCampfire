//
//  ProfileScreenView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 06.03.24.
//

import SwiftUI

struct ProfileScreenView: View {
    @ObservedObject var profileScreenVm: ProfileScreenViewModel
    @EnvironmentObject var authVm: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @AppStorage("homeLat") var homeBaseLatitude: Double = 49.849
    @AppStorage("homeLong") var homeBaseLongitude: Double = 8.44
    @State private var showHomeBaseAlert: Bool = false
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    @State private var showHomeBaseMapKit: Bool = false
    @State var showSettingsSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        let userName = authVm.user?.userName ?? "User unbekannt"
        let userEmail = authVm.user?.email ?? "Email unbekannt"
        let userProfileImage = authVm.user?.imageUrl ?? ""
        NavigationStack {
            VStack {
                Divider()
                VStack{
                    VStack{
                        HStack{
                            VStack(alignment: .leading){
                                Button{
                                    showImagePicker.toggle()
                                } label: {
                                    if !userProfileImage.isEmpty && selectedImage == nil{
                                        AsyncImage(
                                            url: URL(string: userProfileImage),
                                            content: { image in
                                                image
                                                    .resizable()
                                                    .clipShape(Circle())
                                                    .frame(width: 80, height: 80, alignment: .center)
                                                    .overlay(
                                                        Circle()
                                                            .stroke(Color.cyan, lineWidth: 2))
                                            },
                                            placeholder: {
                                                Image(systemName: "photo.badge.plus")
                                                    .frame(width: 80,  height: 80, alignment: .center)
                                                    .font(.system(size: 40))
                                                    .overlay(
                                                        Circle()
                                                            .stroke(Color.cyan, lineWidth: 2)
                                                    )
                                            }
                                        )
                                    } else
                                        if authVm.selectedImage != nil {
                                            Image(uiImage: authVm.selectedImage!)
                                                .resizable()
                                                .clipShape(Circle())
                                                .frame(width: 80, height: 80, alignment: .center)
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.cyan, lineWidth: 2))
                                        } 
//                                        else {
//                                            Image(.logo)
//                                                .resizable()
//                                                .clipShape(Circle())
//                                                .frame(width: 80, height: 80, alignment: .leading)
//                                                .overlay(
//                                                    Circle()
//                                                        .stroke(Color.cyan, lineWidth: 2))
//                                        }
                                    
                                }
                                    Button{
                                        authVm.profileImageToStorage()
                                        if !userProfileImage.isEmpty {
                                            authVm.deleteProfileImage(imageUrl: userProfileImage)
                                        }
                                    } label: {
                                        Text("   Speichern")
                                            .font(.system(size: 12))
                                    }
                                    .offset(x: 0, y: -4)
                                }
                            Spacer()
                            VStack(alignment: .trailing){
                                HStack{
                                    Image(systemName: "mappin.and.ellipse")
                                        .foregroundColor(.red)
                                    Button("HomeBase Koordinaten"){
                                        showHomeBaseAlert.toggle()
                                    }
                                    .alert("Homebase ändern,\nz.B 33.975", isPresented: $showHomeBaseAlert){
                                        
                                        TextField("Latitude", text: $latitude)
                                            .lineLimit(1)
                                            .textInputAutocapitalization(.never)
                                            .autocorrectionDisabled()
                                        TextField("Longitude", text: $longitude)
                                            .lineLimit(1)
                                            .textInputAutocapitalization(.never)
                                            .autocorrectionDisabled()
                                        Button("Homebase auf Karte wählen"){
                                            showHomeBaseMapKit.toggle()
                                        }
                                        Button("Zurück") {
                                            dismiss()
                                        }
                                        Button("Speichern") {
                                            homeBaseLatitude = Double(latitude) ?? 0.0
                                            homeBaseLongitude = Double(longitude) ?? 0.0
                                        }
                                    }
                                }
                                Text("Latitude \(homeBaseLatitude)")
                                    .font(.system(size: 13))
                                Text("Longitude \(homeBaseLongitude)")
                                    .font(.system(size: 13))
                            }
                            .padding(7)
                            .background(Color.cyan.opacity(0.3))
                            .cornerRadius(10)
                            
                            
                        }
                        .frame(width: 350, alignment: .leading)
                        
                        Spacer()
                        HStack{
                            Text(userName)
                                .bold()
                            Spacer()
                            Text(userEmail)
                        }
                        .frame(width: 300, alignment: .leading)
                        Spacer()
                        HStack{
                            Text("UserId: \(FirebaseManager.shared.userId ?? "no user Id")")
                                .font(.caption)
                        }
                        .frame(width: 300, alignment: .leading)
                    }
                }
                .frame(height: 170, alignment: .leading)
                VStack{
                    Divider()
                        .background(.gray)
                    Spacer()
                    Text("Meine gespeicherten Nachrichten")
                        .font(.headline)
                        .bold()
                        .italic()
                        .frame(width: 300, alignment: .leading)
                    ScrollView{
                        ForEach(profileScreenVm.chatLikedViewModels){ chatLikedViewModel in
                            ChatItemView(chatSenderVm: chatLikedViewModel)
                                .id(chatLikedViewModel.id)
                        }
                    }
                    .frame(width: 300, alignment: .center)
                }
                Divider()
            }
            .toolbar{
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading){
                    Button {
                        showSettingsSheet.toggle()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing){
                    Button {
                        profileScreenVm.removeListener()
                        authVm.logout()
                    } label: {
                        Text("Ausloggen")
                        Image(systemName: "door.left.hand.open")
                    }
                }
            }
            .navigationBarTitle("Mein Profil", displayMode: .inline)
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
                    .ignoresSafeArea(.all))
        }
        .sheet(isPresented: $showHomeBaseMapKit) {
            HomeBaseSheetView(profileScreenVm: profileScreenVm)
        }
        .sheet(isPresented: $showSettingsSheet) {
            SettingsScreenView()
        }
        .sheet(isPresented: $showImagePicker, onDismiss: nil) {
            ImagePicker(selectedImage: $authVm.selectedImage, showImagePicker: $showImagePicker)
        }
        .onAppear{
            profileScreenVm.readLikedMessages()
        }
        .onDisappear{
            profileScreenVm.removeListener()
        }
        .background(Color(UIColor.systemBackground))
    }
}

#Preview {
    let profileScreenVm = ProfileScreenViewModel(user: UserModel(id: "", email: "", registeredTime: Date(), userName: "Hans", timeStampLastVisitChat: Date(), isActive: true, imageUrl: ""))
    return ProfileScreenView(profileScreenVm: profileScreenVm, showSettingsSheet: false)
        .environmentObject(AuthViewModel())
}






