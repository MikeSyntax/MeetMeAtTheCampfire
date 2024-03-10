//
//  ChatScreenView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 06.03.24.
//

import SwiftUI

struct ChatScreenView: View {
    
    @ObservedObject var chatVm = ChatScreenViewModel()
    @EnvironmentObject var authVm: AuthViewModel
    @State private var newMessage: String = ""
    @State private var isRead: Bool = false
    let chatSenderVm: ChatSenderViewModel
    
    var body: some View {
        let userName = authVm.user?.userName ?? "User unbekannt"
        NavigationStack {
            VStack {
                ScrollView {
                    ScrollViewReader { scrollView in
                        LazyVStack {
                            ForEach(chatVm.chatSenderViewModels) { chatSenderViewModel in
                                ChatSenderView(chatSenderVm: chatSenderViewModel)
                                    .id(chatSenderViewModel.id)
                            }
                        }
                        .onChange(of: chatVm.chatSenderViewModels) {
                            if let lastMessageId = chatVm.chatSenderViewModels.last?.id {
                                scrollView.scrollTo(lastMessageId, anchor: .bottom)
                            }
                        }
                    }
                }
                //Alle Nachrichten als gelesen markieren, allerdings erstmal nur onTap
                .onTapGesture {
                    for chatSenderViewModel in chatVm.chatSenderViewModels {
                        chatVm.updateReadStatus(chatSenderVm: chatSenderViewModel)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                
                HStack {
                    TextField("Neue Nachricht", text: $newMessage)
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled()
                        .padding()
                    
                    ButtonTextAction(iconName: "plus", text: "Neu") {
                        chatVm.createNewMessage(userName: userName, messageText: newMessage, isRead: isRead)
                        newMessage = ""
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Chat")
            .toolbar {
                Button{
                    //todo Search
                } label: {
                    Text("Suche")
                    Image(systemName: "magnifyingglass")
                }
            }
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
                    .ignoresSafeArea())
        }
        .onAppear {
            chatVm.readMessages()
            //chatVm.updateReadStatus(chatSenderVm: chatSenderVm)
        }
        .onDisappear{
            chatVm.removeListener()
        }
    }
}

#Preview {
    ChatScreenView(chatSenderVm: ChatSenderViewModel(chatDesign: ChatModel(userId: "2", userName: "Dieter", messageText: "Danke", timeStamp: Date(), isRead: false)))
        .environmentObject(AuthViewModel())
}
