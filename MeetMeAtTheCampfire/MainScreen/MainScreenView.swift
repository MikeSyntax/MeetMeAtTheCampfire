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
    @StateObject var languageVm = LanguageScreenViewModel(languageChoice: Language(code: "af", name: "Afrikaans"), languageSource: Language(code: "de", name: "Deutsch"))
    @StateObject var chatSenderVm = ChatSenderViewModel(chatDesign: ChatModel(userId: "2", userName: "Dieter", messageText: "Danke", timeStamp: Date(), isReadbyUser: []))
    //@StateObject var dateVm = CalendarViewModel(date: Date())
    
    @StateObject var dateVm = {
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.year], from: currentDate)
        return CalendarViewModel(date: calendar.date(from: components) ?? Date())
    }()
    
    @StateObject var calendarDetailItemVm = CalendarDetailItemViewModel(calendarItemModel: LogBookModel(userId: "1", formattedDate: "123", logBookText: "", laditude: 0.47586, longitude: 0.883626), calendarVm: CalendarViewModel(date: Date()))
    
    //Immer mit der HomeScreenView anfangen
    @State private var selectedTab = 0
    
    init(authVm: AuthViewModel){
        _chatVm = StateObject(wrappedValue: ChatScreenViewModel(user: authVm.user!))
        self.authVm = authVm
    }
    
    var body: some View {
        TabView{
            HomeScreenView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }.tag(0)
            
            ChatScreenView(chatVm: self.chatVm)
                .tabItem {
                    Image(systemName: "message")dfg
                    Text("Chat")
                }
                .badge(/*unreadedMessages*/ chatVm.messageCountResult)
                .tag(1)
            
            CalendarYearlyView(dateVm: dateVm, calendarDetailItemVm: calendarDetailItemVm)
                .tabItem {
                    Image(systemName: "book")
                    Text("Logbuch")
                }.tag(2)
            
            LanguageScreenView(languageVm: self.languageVm)
                .tabItem {
                    Image(systemName: "network")
                    Text("Übersetzer")
                }.tag(3)
            
            ProfileScreenView()
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
    }
}
