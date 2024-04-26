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
    @AppStorage("isDarkMode") var isDark: Bool = false
    @AppStorage("homeLat") var homeBaseLatitude: Double = 49.849
    @AppStorage("homeLong") var homeBaseLongitude: Double = 8.44
    @State private var showHomeBaseAlert: Bool = false
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    
    var body: some View {
        let userName = authVm.user?.userName ?? "User unbekannt"
        let userEmail = authVm.user?.email ?? "Email unbekannt"
        NavigationStack {
            VStack {
                Divider()
                VStack{
                    VStack{
                        HStack{
                            Image(.logo)
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 100, height: 100, alignment: .leading)
                            Spacer()
                            
                            VStack(alignment: .trailing){
                                HStack{
                                    Image(systemName: "mappin.and.ellipse")
                                        .foregroundColor(.red)
                                    Button("HomeBase Koordinaten"){
                                        showHomeBaseAlert.toggle()
                                    }
                                    .alert("Homebase ändern,\nz.B 33.975", isPresented: $showHomeBaseAlert){
                                        if isDark {
                                            TextField("Latitude", text: $latitude)
                                                .lineLimit(1)
                                                .textInputAutocapitalization(.never)
                                                .autocorrectionDisabled()
                                                .foregroundColor(.black)
                                        } else {
                                            TextField("Latitude", text: $latitude)
                                                .lineLimit(1)
                                                .textInputAutocapitalization(.never)
                                                .autocorrectionDisabled()
                                                .foregroundColor(.primary)
                                        }
                                        if isDark {
                                            TextField("Longitude", text: $longitude)
                                                .lineLimit(1)
                                                .textInputAutocapitalization(.never)
                                                .autocorrectionDisabled()
                                                .foregroundColor(.black)
                                        } else {
                                            TextField("Longitude", text: $longitude)
                                                .lineLimit(1)
                                                .textInputAutocapitalization(.never)
                                                .autocorrectionDisabled()
                                                .foregroundColor(.primary)
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
                            Text("Id: \(FirebaseManager.shared.userId ?? "no user Id")")
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
            .toolbar {
                Button {
                    profileScreenVm.removeListener()
                    authVm.logout()
                    
                } label: {
                    Text("Ausloggen")
                    Image(systemName: "door.left.hand.open")
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
        .onAppear{
            profileScreenVm.readLikedMessages()
        }
        .onDisappear{
            profileScreenVm.removeListener()
        }
    }
}

#Preview {
    let profileScreenVm = ProfileScreenViewModel(user: UserModel(id: "", email: "", registeredTime: Date(), userName: "Hans", timeStampLastVisitChat: Date()))
    return ProfileScreenView(profileScreenVm: profileScreenVm)
        .environmentObject(AuthViewModel())
}
