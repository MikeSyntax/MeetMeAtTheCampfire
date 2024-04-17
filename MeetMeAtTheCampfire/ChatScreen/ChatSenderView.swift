//
//  ChatSenderView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 07.03.24.
//

import SwiftUI

struct ChatSenderView: View {
    
    @ObservedObject var chatSenderVm: ChatSenderViewModel
    private let maxWidth: CGFloat = 300.0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(chatSenderVm.isCurrentUser ? Color.cyan.opacity(0.6) : Color.green.opacity(0.6))
                .frame(minWidth: 200, maxWidth: maxWidth, minHeight: 70, maxHeight: 500, alignment: chatSenderVm.isCurrentUser ? .trailing : .leading)
                .shadow(radius: 10)
            VStack{
                HStack{
                    Image(.logo)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .clipShape(Circle())
                    
                    Text(chatSenderVm.userName)
                        .font(.caption)
                    
                }
                .padding(.trailing)
                .padding(.leading)
                .padding(.vertical, 2)
                .frame(maxWidth: maxWidth, alignment: chatSenderVm.isCurrentUser ? .trailing : .leading)
                
                Text(chatSenderVm.messageText)
                    .lineLimit(1...)
                    .font(.headline)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.vertical, 2)
                    .frame(maxWidth: maxWidth, alignment: chatSenderVm.isCurrentUser ? .trailing : .leading)

                Spacer()
                HStack{
                Text(chatSenderVm.dateString)
                    .font(.caption)
                    .padding(.trailing)
                    .padding(.leading)
                    .padding(.vertical, 2)
                    .frame(maxWidth: maxWidth, alignment: chatSenderVm.isCurrentUser ? .trailing : .leading)

                if chatSenderVm.isReadbyUser.contains(chatSenderVm.userId) {
                    CheckmarkIsRead()
                } else {
                    CheckmarkNotRead()
                }
                }
            }
            .frame(minWidth: 200, maxWidth: maxWidth, minHeight: 70, maxHeight: 500, alignment: chatSenderVm.isCurrentUser ? .leading : .trailing)

            .padding(2)
        }
        .frame(minWidth: 200, maxWidth: .infinity, minHeight: 70, maxHeight: 500, alignment: chatSenderVm.isCurrentUser ? .trailing : .leading)

    }
}

#Preview {
    let chat = ChatModel(userId: "1", userName: "Fettes Brot", messageText: "In diesem Beispiel wird der Text innerhalb des Rechtecks angezeigt, und die Höhe des Rechtecks passt sich automatisch an die Höhe des Textinhalts an. Die fixedSize(horizontal:vertical:)-Modifikator sorgt dafür, dass der Text nicht über die Breite des Rechtecks hinauswächst, aber vertikal kann er beliebig wachsen. Damit sollten längere Texte vollständig angezeigt werden.", timeStamp: Date(), isReadbyUser: [])
    let chatVm = ChatSenderViewModel(chatDesign: chat)
    return ChatSenderView(chatSenderVm: chatVm)
}


