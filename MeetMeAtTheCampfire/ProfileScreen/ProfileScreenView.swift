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
                                .underline()
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
