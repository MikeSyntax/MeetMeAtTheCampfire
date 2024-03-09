//
//  MainScreenView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 06.03.24.
//

import SwiftUI

struct MainScreenView: View {
    
    @StateObject var chatVm = ChatScreenViewModel()
    @StateObject var languageVm = LanguageScreenViewModel(languageChoice: Language(code: "en", name: "Englisch"))
    
    var body: some View {
        TabView{
            HomeScreenView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }.tag(0)
            
            ChatScreenView(chatVm: self.chatVm)
                .tabItem {
                    Image(systemName: "message")
                    Text("Chat")
                }
                .badge(self.chatVm.newMessagesCount)
                .tag(1)
            
            LanguageScreenView(languageVm: languageVm)
                .tabItem {
                    Image(systemName: "network")
                    Text("Übersetzer")
                }.tag(2)
            
            ProfileScreenView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profil")
                }.tag(3)
        }
    }
}

#Preview {
    MainScreenView()
}
