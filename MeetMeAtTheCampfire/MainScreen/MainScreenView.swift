//
//  MainScreenView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 06.03.24.
//

import SwiftUI

struct MainScreenView: View {
    
    @StateObject var chatVm = ChatScreenViewModel()
    @StateObject var languageVm = LanguageScreenViewModel(languageChoice: Language(code: "af", name: "Afrikaans"), languageSource: Language(code: "de", name: "Deutsch"))
    @StateObject var chatSenderVm = ChatSenderViewModel(chatDesign: ChatModel(userId: "2", userName: "Dieter", messageText: "Danke", timeStamp: Date(), isRead: false))
    //Immer mit der HomeScreenView anfangen
    @State private var selectedTab = 0
    
    
    var body: some View {
        TabView{
            HomeScreenView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }.tag(0)
            
            ChatScreenView(chatVm: self.chatVm, chatSenderVm: chatSenderVm)
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
        .onAppear{
            selectedTab = 0
        }
    }
}

#Preview {
    MainScreenView()
}
