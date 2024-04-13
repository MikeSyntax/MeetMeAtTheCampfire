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
            .frame(minWidth: 200, maxWidth: 300, minHeight: 100)
            .overlay(
                VStack{
                    //Absendername
                    HStack{
                        Image(.logo)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        Text(chatSenderVm.userName)
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity, alignment: chatSenderVm.isCurrentUser ? .trailing : .leading)
                    .padding(.trailing)
                    .padding(.leading)
                    //Nachricht
                    Text(chatSenderVm.messageText)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: chatSenderVm.isCurrentUser ? .leading : .trailing)
                        .padding(.leading)
                        .padding(.trailing)
                    Spacer()
                    //Datum und Uhrzeit der Nachricht
                    HStack{
                        Text(chatSenderVm.dateString)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: chatSenderVm.isCurrentUser ? .trailing : .leading)
                            .padding(.trailing)
                            .padding(.leading)
                        if chatSenderVm.isReadbyUser.contains(chatSenderVm.userId) {
                            CheckmarkIsRead()
                        } else {
                            CheckmarkNotRead()
                        }
                    }
                }
                    .padding(2)
            )
            .frame(maxWidth: .infinity, alignment: chatSenderVm.isCurrentUser ? .trailing : .leading)
            .shadow(radius: 10)
    }
}

#Preview {
    let chat = ChatModel(userId: "1", userName: "Fettes Brot", messageText: "In diesem Beispiel wird der Text innerhalb des Rechtecks angezeigt, und die Höhe des Rechtecks passt sich automatisch an die Höhe des Textinhalts an. Die fixedSize(horizontal:vertical:)-Modifikator sorgt dafür, dass der Text nicht über die Breite des Rechtecks hinauswächst, aber vertikal kann er beliebig wachsen. Damit sollten längere Texte vollständig angezeigt werden.", timeStamp: Date(), isReadbyUser: [])
    let chatVm = ChatSenderViewModel(chatDesign: chat)
    return ChatSenderView(chatSenderVm: chatVm)
}


