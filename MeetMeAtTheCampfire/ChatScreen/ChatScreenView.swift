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
    
    var body: some View {
        let userName = authVm.user?.userName ?? "User unbekannt"
        
        NavigationView {
            VStack {
                ScrollView {
                    ScrollViewReader { scrollView in
                        LazyVStack {
                            ForEach(chatVm.chatSenderViewModels) { chatSenderViewModel in
                                ChatSenderView(chatSenderVm: chatSenderViewModel)
                                    .id(chatSenderViewModel.id)
                            }
                        }
                        .onChange(of: chatVm.chatSenderViewModels) { _ in
                            if let lastMessageId = chatVm.chatSenderViewModels.last?.id {
                                scrollView.scrollTo(lastMessageId, anchor: .bottom)
                            }
                        }
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
                        chatVm.createNewMessage(userName: userName, messageText: newMessage)
                        newMessage = ""
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Chat")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        //todo Search
                    }) {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
        }
        .onAppear {
            chatVm.readMessages()
        }
    }
}


#Preview {
    ChatScreenView(chatVm: ChatScreenViewModel())
        .environmentObject(AuthViewModel())
}
