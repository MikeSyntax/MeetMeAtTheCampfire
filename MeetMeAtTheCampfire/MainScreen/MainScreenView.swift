//
//  MainScreenView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 06.03.24.
//

import SwiftUI

struct MainScreenView: View {
    let authVm: AuthViewModel
    @StateObject var chatVm: ChatScreenViewModel
    @StateObject var profileScreenVm: ProfileScreenViewModel
    @StateObject var languageVm = LanguageScreenViewModel(languageChoice: Language(code: "af", name: "Afrikaans"), languageSource: Language(code: "de", name: "Deutsch"))
    @StateObject var chatSenderVm = ChatItemViewModel(chatDesign: ChatModel(userId: "2", userName: "Dieter", messageText: "Danke", timeStamp: Date(), isReadbyUser: [], isLiked: false, isLikedByUser: []))
    @State private var selectedTab = 0
    
    init(authVm: AuthViewModel){
        _chatVm = StateObject(wrappedValue: ChatScreenViewModel(user: authVm.user!))
        _profileScreenVm = StateObject(wrappedValue: ProfileScreenViewModel(user: authVm.user!))
        self.authVm = authVm
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeScreenView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }.tag(0)
            
            ChatScreenView(chatVm: self.chatVm)
                .tabItem {
                    Image(systemName: "flame")
                    Text("Campfire")
                }
                .badge(chatVm.messageCountResult)
                .tag(1)
            
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
        .onChange(of: authVm.user?.id){
            selectedTab = 0
        }
        .onDisappear{
            authVm.updateUser()
        }
       // .environment(\.colorScheme, isDark ? .dark : .light)
        .background(Color(UIColor.systemBackground))
    }
}

