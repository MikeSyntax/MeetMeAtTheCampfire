//
//  ChatScreenViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 07.03.24.
//

import Foundation

class ChatScreenViewModel: ObservableObject {
    
    //Leere Liste an Nachrichten
    @Published var chatSenderViewModels: [ChatSenderViewModel] = [
    ChatSenderViewModel(chatDesign: ChatModel(userId: "1", userName: "Dieter", messageText: "Huhu", isCurrentUser: false)),
    ChatSenderViewModel(chatDesign: ChatModel(userId: "2", userName: "Tamara", messageText: "Wieviel Geld sollte ich mitnehmen", isCurrentUser: true)),
    ChatSenderViewModel(chatDesign: ChatModel(userId: "3", userName: "Klaus", messageText: "Das kommt ganz darauf an, wie lange du bleiben willst", isCurrentUser: false))]
        
}
