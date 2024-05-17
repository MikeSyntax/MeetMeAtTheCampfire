//
//  ProfileScreenView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 06.03.24.
//

import SwiftUI
import SwiftData

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
    @Environment(\.modelContext) private var context
    @Query private var blockedUsers: [BlockedUser]
    
    var body: some View {
        let userName = authVm.user?.userName ?? "User unbekannt"
        let userEmail = authVm.user?.email ?? "Email unbekannt"
        let edgeInsets: EdgeInsets = EdgeInsets(
            top: 0,
            leading: 10,
            bottom: 0,
            trailing: 10)
        
        NavigationStack {
            VStack {
                Divider()
                VStack{
                    VStack{
                        HStack(alignment: .top){
                            VStack(alignment: .center){
                                Button{
                                    showImagePicker.toggle()
                                } label: {
                                    if authVm.selectedImage != nil {
                                        ZStack{
                                            Image(uiImage: authVm.selectedImage!)
                                                .resizable()
                                                .clipShape(Circle())
                                                .scaledToFill()
                                                .frame(
                                                    width: 80,
                                                    height: 80)
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.cyan, lineWidth: 2))
                                            Image(systemName: "dot.circle.and.hand.point.up.left.fill")
                                                .font(.system(size: 25))
                                                .offset(x: 45, y: -20)
                                            
                                            if authVm.showSuccessTick {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(.green)
                                                    .font(.system(size: 50))
                                                    .bold()
                                                    .shadow(color: Color.white, radius: 5)
                                                    .transition(.scale)
                                            }
                                        }
                                    } else {
                                        AsyncImage(
                                            url: URL(string: authVm.imageUrl),
                                            content: { image in
                                                ZStack{
                                                    image
                                                        .resizable()
                                                        .clipShape(Circle())
                                                        .scaledToFill()
                                                        .frame(
                                                            width: 80,
                                                            height: 80)
                                                        .overlay(
                                                            Circle()
                                                                .stroke(Color.cyan, lineWidth: 2))
                                                    Image(systemName: "dot.circle.and.hand.point.up.left.fill")
                                                        .font(.system(size: 25))
                                                        .offset(x: 45, y: -20)
                                                }
                                            },
                                            placeholder: {
                                                Image(systemName: "photo.badge.plus")
                                                    .frame(
                                                        width: 80,
                                                        height: 80)
                                                    .font(.system(size: 40))
                                                    .overlay(
                                                        Circle()
                                                            .stroke(Color.cyan, lineWidth: 2))
                                            }
                                        )
                                    }
                                }
                                Button{
                                    Task{
                                        await authVm.profileImageToStorage()
                                        if !authVm.imageUrl.isEmpty {
                                            await authVm.deleteProfileImage(imageUrl: authVm.imageUrl)
                                        }
                                    }
                                    authVm.updateImageUrl(withId: FirebaseManager.shared.userId ?? "no user found")
                                } label: {
                                    Text("Speichern")
                                        .font(.system(size: 14))
                                        .bold()
                                }
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
                        .padding(edgeInsets)
                        Spacer()
                        HStack{
                            Text(userName)
                                .bold()
                            Spacer()
                            Text(userEmail)
                                .font(.caption)
                        }
                        .padding(edgeInsets)
                        Spacer()
                        HStack{
                            Text("UserId: \(FirebaseManager.shared.userId ?? "no user Id")")
                                .font(.caption)
                        }
                        .padding(edgeInsets)
                    }
                }
                .frame(
                    height: 170,
                    alignment: .leading)
                VStack{
                    Divider()
                        .background(.gray)
                    Spacer()
                    Text("Meine gespeicherten Nachrichten")
                        .font(.headline)
                        .bold()
                        .italic()
                        .padding(edgeInsets)
                    ScrollView{
                        ForEach(profileScreenVm.chatLikedViewModels){ chatLikedViewModel in
                            ChatItemView(chatSenderVm: chatLikedViewModel)
                                .id(chatLikedViewModel.id)
                        }
                    }
                    .padding(edgeInsets)
                    VStack{
                        Text("Liste mit blockierten Usern")
                            .font(.headline)
                            .bold()
                            .italic()
                            .padding(edgeInsets)
                        List{
                            ForEach (blockedUsers){ item in
                                HStack{
                                    Text(item.userName)
                                        .font(.system(size: 12))
                                    Spacer()
                                    Text("swipen zum Rückgängigmachen")
                                        .font(.system(size: 10))
                                }
                            }
                            .onDelete{ indexes in
                                for index in indexes {
                                    deleteItem(blockedUsers[index])
                                }
                            }
                        }
                        .padding(.top, -35)
                        .frame(maxHeight: 130)
                        .background(Color.clear)
                        .cornerRadius(10)
                        .scrollContentBackground(.hidden)
                    }
                    .padding(edgeInsets)
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
            authVm.readAppUser(withId: authVm.user?.id ?? "no user found")
            authVm.updateImageUrl(withId: authVm.user?.id ?? "no user found")
        }
        .onChange(of: authVm.imageUrl){
            authVm.readAppUser(withId: authVm.user?.id ?? "no user found")
        }
        .onDisappear{
            profileScreenVm.removeListener()
            authVm.selectedImage = nil
        }
        .background(Color(UIColor.systemBackground))
    }
    
    //BlockedUser delete from SwiftData
    func deleteItem(_ blockedUser: BlockedUser){
        context.delete(blockedUser)
    }
}

#Preview {
    let profileScreenVm = ProfileScreenViewModel(user: UserModel(id: "", email: "", registeredTime: Date(), userName: "Hans", timeStampLastVisitChat: Date(), isActive: true, imageUrl: ""))
    return ProfileScreenView(profileScreenVm: profileScreenVm, showSettingsSheet: false)
        .environmentObject(AuthViewModel())
        .modelContainer(for: [LogBookAtivity.self, BlockedUser.self])
}



