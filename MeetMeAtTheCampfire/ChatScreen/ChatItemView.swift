//
//  ChatItemView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 07.03.24.
//

import SwiftUI

struct ChatItemView: View {
    
    @ObservedObject var chatSenderVm: ChatItemViewModel
    private let maxWidth: CGFloat = 300.0
    private let userId = FirebaseManager.shared.userId
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(chatSenderVm.isCurrentUser ? Color.cyan.opacity(0.6) : Color.green.opacity(0.6))
                .frame(minWidth: 180, maxWidth: maxWidth, minHeight: 70, maxHeight: 500, alignment: chatSenderVm.isCurrentUser ? .trailing : .leading)
                .shadow(radius: 10)
            VStack{
                HStack{
                    Image(.logo)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .clipShape(Circle())
                    Text(chatSenderVm.userName)
                        .font(.caption)
                    Spacer()
                    Text("UserId: \(chatSenderVm.userId)")
                        .font(.system(size: 8))
                }
                .padding(EdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5))
                .frame(maxWidth: maxWidth, alignment: chatSenderVm.isCurrentUser ? .trailing : .leading)
                Text(chatSenderVm.messageText)
                    .lineLimit(1...)
                    .font(.system(size: 15))
                    .padding(EdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5))
                    .frame(maxWidth: maxWidth, alignment: chatSenderVm.isCurrentUser ? .trailing : .leading)
                Spacer()
                HStack{
                    if chatSenderVm.isLiked {
                        Button{
                            chatSenderVm.isLiked.toggle()
                            chatSenderVm.updateIsLikedStatus(chatSenderVm: chatSenderVm)
                        } label: {
                            if chatSenderVm.isLikedByUser.contains(userId ?? "no UserId"){
                                Image(systemName: "star.fill")
                                    .frame(alignment: chatSenderVm.isCurrentUser ? .trailing : .leading)
                                    .bold()
                                    .foregroundColor(.primary)
                            } else {
                                Image(systemName: "star")
                                    .frame(alignment: chatSenderVm.isCurrentUser ? .trailing : .leading)
                                    .bold()
                                    .foregroundColor(.primary)
                            }
                        }
                    } else {
                        Button{
                            chatSenderVm.isLiked.toggle()
                            chatSenderVm.updateIsLikedStatus(chatSenderVm: chatSenderVm)
                        } label: {
                            Image(systemName: "star")
                                .frame(alignment: chatSenderVm.isCurrentUser ? .trailing : .leading)
                                .bold()
                                .foregroundColor(.primary)
                        }
                   }
                    Text(chatSenderVm.dateString)
                        .font(.caption)
                        .frame(maxWidth: maxWidth, alignment: chatSenderVm.isCurrentUser ? .trailing : .leading)
                    if chatSenderVm.isReadbyUser.contains(chatSenderVm.userId) {
                        CheckmarkIsRead()
                    } else {
                        CheckmarkNotRead()
                    }
                }
                .padding(EdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5))
            }
            .frame(minWidth: 180, maxWidth: maxWidth, minHeight: 70, maxHeight: 500, alignment: chatSenderVm.isCurrentUser ? .leading : .trailing)
            .padding(2)
        }
        .frame(minWidth: 180, maxWidth: .infinity, minHeight: 70, maxHeight: 500, alignment: chatSenderVm.isCurrentUser ? .trailing : .leading)
    }
}

#Preview {
    let chat = ChatModel(userId: "1", userName: "Fettes Brot", messageText: "In diesem Beispiel wird der Text innerhalb des Rechtecks angezeigt, und die Höhe des Rechtecks passt sich automatisch an die Höhe des Textinhalts an. Die fixedSize(horizontal:vertical:)-Modifikator sorgt dafür, dass der Text nicht über die Breite des Rechtecks hinauswächst, aber vertikal kann er beliebig wachsen. Damit sollten längere Texte vollständig angezeigt werden.", timeStamp: Date(), isReadbyUser: [], isLiked: false, isLikedByUser: [])
    let chatVm = ChatItemViewModel(chatDesign: chat)
    return ChatItemView(chatSenderVm: chatVm)
}


