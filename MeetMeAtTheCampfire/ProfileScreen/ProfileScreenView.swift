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
    
    //After Logout start with selectedTab
    //var onLogout: (()-> Void)?
    
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
                            Spacer()
                            Text(userEmail)
                        }
                        .frame(width: 300, alignment: .leading)
                        Spacer()
                        HStack{
                            Text("Id: \(FirebaseManager.shared.userId ?? "no user Id")")
                                .underline()
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
                            ChatSenderView(chatSenderVm: chatLikedViewModel)
                                .id(chatLikedViewModel.id)
                        }
                    }
                    .frame(width: 300, alignment: .center)
                }
            }
            .padding()
            .toolbar {
                Button {
                    authVm.logout()
                  //  onLogout?()
                } label: {
                    Text("Logout")
                    Image(systemName: "door.left.hand.open")
                }
            }
            .navigationBarTitle("Profil")
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
                    .ignoresSafeArea())
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
    ProfileScreenView(profileScreenVm: ProfileScreenViewModel(user: UserModel(id: "", email: "", registeredTime: Date(), userName: "Hans", timeStampLastVisitChat: Date())))
        .environmentObject(AuthViewModel())
}
