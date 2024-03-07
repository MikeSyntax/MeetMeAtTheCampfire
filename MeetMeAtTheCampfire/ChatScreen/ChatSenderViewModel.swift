//
//  ChatSenderViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 07.03.24.
//

import Foundation

class ChatSenderViewModel: ObservableObject, Identifiable, Equatable {
    
    static func == (lhs: ChatSenderViewModel, rhs: ChatSenderViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    @Published var userName: String = ""
    @Published var messageText: String = ""
    @Published var dateString: String = ""
    @Published var isCurrentUser: Bool = false
    private var timeStamp = Date()
    
    let chatSenderVm: ChatModel
    
    init(chatDesign: ChatModel, isCurrentUser: Bool = false) {
        self.chatSenderVm = chatDesign
        self.userName = chatDesign.userName
        self.timeStamp = chatDesign.timeStamp
        self.messageText = chatDesign.messageText
        self.isCurrentUser = isCurrentUser
        
        updateDate()
    }
    
    func updateDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.dateString = formatter.string(from: timeStamp)
    }
}
