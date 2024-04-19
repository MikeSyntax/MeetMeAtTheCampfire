//
//  ChatScreenView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 06.03.24.
//

import SwiftUI
import Foundation

struct ChatScreenView: View {
    
    @ObservedObject var chatVm: ChatScreenViewModel
    @EnvironmentObject var authVm: AuthViewModel
    @State private var newMessage: String = ""
    @State private var matchingChatIds: [String] = []
    
    var body: some View {
        let userName = authVm.user?.userName ?? "User name unknown"
        let currentUser = authVm.user?.id ?? "No current user"
        NavigationStack {
            VStack {
                Divider()
                ScrollView {
                    ScrollViewReader { scrollView in
                        LazyVStack {
                            ForEach(chatVm.chatSenderViewModels) { chatSenderViewModel in
                                ChatSenderView(chatSenderVm: chatSenderViewModel)
                                    .id(chatSenderViewModel.id)
                                    .onAppear {
                                        if
                                            !chatSenderViewModel.isReadbyUser.contains(currentUser) {
                                            chatVm.updateisReadStatus(chatSenderVm: chatSenderViewModel)
                                        }
                                    }
                            }
                        }
                        .onChange(of: chatVm.chatSenderViewModels) {
                            // if let lastMessageId = chatVm.chatSenderViewModels.last?.isReadbyUser.last {
                            if let lastMessageId = chatVm.chatSenderViewModels.last?.id {
                                scrollView.scrollTo(lastMessageId, anchor: .bottom)
                            }
                            authVm.user?.timeStampLastVisitChat = Date.now
                        }
                        .onChange(of: chatVm.searchTerm) { newSearchTerm, _ in
                            if !newSearchTerm.isEmpty {
                                chatVm.readMessages()
                                matchingChatIds = chatVm.searchMessages(for: newSearchTerm)
                                if !matchingChatIds.isEmpty {
                                    let result = matchingChatIds[0]
                                    scrollView.scrollTo(result, anchor: .bottom)
                                    print("matchingIndex \(result)")
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                Divider()
                    .frame(height: 5)
                HStack {
                    TextField("Neue Nachricht", text: $newMessage)
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled()
                        .padding(0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10) // Erstellen eines gerundeten Rechtecks als Overlay
                                .stroke(Color.cyan, lineWidth: 2) // Farbe und Breite des Rahmens festlegen
                        )
                    ButtonTextAction(iconName: "paperplane", text: "Senden") {
                        chatVm.createNewMessage(userName: userName, messageText: newMessage, isLiked: false, isLikedByUser: [])
                        newMessage = ""
                    }
                }
                .padding(.horizontal)
                Divider()
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
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
            authVm.user?.timeStampLastVisitChat = Date.now
        }
        .onDisappear{
            chatVm.removeListener()
        }
        .searchable(text: $chatVm.searchTerm)
    }
}

#Preview {
    ChatScreenView(chatVm: ChatScreenViewModel(user: UserModel(id: "1", email: "1", registeredTime: Date(), userName: "hallo", timeStampLastVisitChat: Date.now)))
        .environmentObject(AuthViewModel())
}
