//
//  MainScreenView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 06.03.24.
//

import SwiftUI

struct MainScreenView: View {
    
    @StateObject var chatVm = ChatScreenViewModel()
    
    var body: some View {
        TabView{
            HomeScreenView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }.tag(0)
            
            ChatScreenView(chatVm: chatVm)
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Chat")
                }.tag(1)
            
            ProfileScreenView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profil")
                }.tag(2)
        }
    }
}

#Preview {
    MainScreenView()
}
