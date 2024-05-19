//
//  MainScreenView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 06.03.24.
//

import SwiftUI

struct MainScreenView: View {
    
    @EnvironmentObject var authVm :AuthViewModel
    
    @StateObject var chatVm = ChatScreenViewModel(
        user: UserModel(id: "",
                        email: "",
                        registeredTime: Date(),
                        userName: "",
                        timeStampLastVisitChat: Date(),
                        isActive: true,
                        imageUrl: ""))
    
    @StateObject var profileScreenVm = ProfileScreenViewModel(
        user: UserModel(id: "",
                        email: "",
                        registeredTime: Date(),
                        userName: "",
                        timeStampLastVisitChat: Date(),
                        isActive: true,
                        imageUrl: ""))
    
    @StateObject var languageVm = LanguageScreenViewModel(
        languageChoice: Language(code: "af", name: "Afrikaans"),
        languageSource: Language(code: "de", name: "Deutsch"))
    
//    @StateObject var chatSenderVm = ChatItemViewModel(
//        chatDesign: ChatModel(userId: "2",
//                              userName: "Dieter",
//                              messageText: "Danke",
//                              timeStamp: Date(),
//                              isReadbyUser: [],
//                              isLiked: false,
//                              isLikedByUser: [],
//                              profileImage: ""))
    
    @State private var selectedTab = 0
    @AppStorage("badgevisible") private var isBadgeVisible: Bool = true
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            HomeScreenView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }.tag(0)
            
            if isBadgeVisible {
                ChatScreenView(chatVm: self.chatVm)
                    .environmentObject(authVm)
                    .tabItem {
                        Image(systemName: "flame")
                        Text("Campfire")
                    }
                    .badge(chatVm.messageCountResult)
                    .tag(1)
            } else {
                ChatScreenView(chatVm: self.chatVm)
                    .environmentObject(authVm)
                    .tabItem {
                        Image(systemName: "flame")
                        Text("Campfire")
                    }
                    .tag(1)
            }
            
            CalendarYearlyView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "book":"book.closed")
                    Text("Logbuch")
                }.tag(2)
            
            LanguageScreenView(languageVm: self.languageVm)
                .tabItem {
                    Image(systemName: "network")
                    Text("Übersetzer")
                }.tag(3)
            
            ProfileScreenView(profileScreenVm: profileScreenVm)
                .environmentObject(authVm)
                .tabItem {
                    Image(systemName: "person")
                    Text("Profil")
                }.tag(4)
        }
        .onAppear{
            selectedTab = 0
            chatVm.readMessages()
        }
        .onChange(of: selectedTab){
            if selectedTab == 1 {
                authVm.user!.timeStampLastVisitChat = Date.now
            }
        }
        .onDisappear{
            authVm.updateUser()
        }
        .onChange(of: authVm.user?.id){
            selectedTab = 0
        }
        .background(Color(UIColor.systemBackground))
    }
}

