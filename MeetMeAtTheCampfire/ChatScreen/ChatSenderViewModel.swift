//
//  ChatSenderViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 07.03.24.
//

import Foundation

class ChatSenderViewModel: ObservableObject, Identifiable {
    
    @Published var userName: String = ""
    @Published var timeStamp = Date()
    @Published var messageText: String = ""
    @Published var isCurrentUser: Bool = false
    
    let chatSenderVm: ChatModel
    
    init(chatDesign: ChatModel){
        self.chatSenderVm = chatDesign.self
        self.userName = chatDesign.userName
     //   self.timeStamp = chatDesign.timeStamp
        self.messageText = chatDesign.messageText
        self.isCurrentUser = chatDesign.isCurrentUser
        
    }
}
