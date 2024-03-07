//
//  ChatSenderView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 07.03.24.
//

import SwiftUI

struct ChatSenderView: View {
    
    @ObservedObject var chatSenderVm: ChatSenderViewModel
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(chatSenderVm.isCurrentUser ? Color.cyan.opacity(0.6) : Color.green.opacity(0.6))
            .frame(width: 300, height: 100)
            .overlay(
                VStack{
                    Text(chatSenderVm.userName)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: chatSenderVm.isCurrentUser ? .trailing : .leading)
                        .padding(.trailing)
                        .padding(.leading)
                    Text(chatSenderVm.messageText)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: chatSenderVm.isCurrentUser ? .leading : .trailing)
                        .padding(.leading)
                        .padding(.trailing)
                    Spacer()
                    Text(chatSenderVm.dateString)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: chatSenderVm.isCurrentUser ? .trailing : .leading)
                        .padding(.trailing)
                        .padding(.leading)
                    
                }
                    
                    .padding(2)
            )
            .frame(maxWidth: .infinity, alignment: chatSenderVm.isCurrentUser ? .trailing : .leading)
            .shadow(radius: 10)
    }
}

#Preview {
    let chat = ChatModel(userId: "1", userName: "Fettes Brot", messageText: "Heute gehen wir campen", timeStamp: Date())
    let chatVm = ChatSenderViewModel(chatDesign: chat)
    return ChatSenderView(chatSenderVm: chatVm)
}


