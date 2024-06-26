//
//  ChatScreenView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 06.03.24.
//
//
import SwiftUI

struct ChatScreenView: View {
    
    @ObservedObject private var chatVm: ChatScreenViewModel
    @EnvironmentObject private var authVm: AuthViewModel
    @State private var newMessage: String = ""
    @State private var matchingChatIds: [String] = []
    @StateObject private var chatManager = ChatManager.shared
    @State private var showReactionPopover: Bool = false
    @State private var selectedChatSenderViewModel: ChatItemViewModel? = nil
    
    init(chatVm: ChatScreenViewModel) {
        self.chatVm = chatVm
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Abbrechen"
    }
    
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
                                ChatItemView(chatSenderVm: chatSenderViewModel)
                                    .id(chatSenderViewModel.id)
                                    .onAppear {
                                        if !chatSenderViewModel.isReadbyUser.contains(currentUser) {
                                            chatVm.updateisReadStatus(chatSenderVm: chatSenderViewModel)
                                        }
                                    }
                            }
                        }
                        .onChange(of: chatManager.excludedUserIds) {
                            chatVm.readMessages()
                        }
                        .onChange(of: chatVm.chatSenderViewModels) {
                            if chatVm.searchTerm.isEmpty {
                                if let lastMessageId = chatVm.chatSenderViewModels.last?.id {
                                    scrollView.scrollTo(lastMessageId, anchor: .bottom)
                                }
                            }
                            authVm.user?.timeStampLastVisitChat = Date.now
                        }
                        .onChange(of: chatVm.searchTerm) { newSearchTerm, _ in
                            if !newSearchTerm.isEmpty {
                                chatVm.readMessages()
                                matchingChatIds = chatVm.searchMessages(for: newSearchTerm)
                                if !matchingChatIds.isEmpty {
                                    if let firstMatchingId = matchingChatIds.first {
                                        let filteredChats = chatVm.chatSenderViewModels.filter { $0.chatSenderVm.id == firstMatchingId }
                                        if let firstFilteredChat = filteredChats.first {
                                            scrollView.scrollTo(firstFilteredChat.id, anchor: .top)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity)
                .padding(
                    EdgeInsets(
                        top: 0,
                        leading: 10,
                        bottom: 0,
                        trailing: 10))
                Divider()
                    .frame(height: 5)
                HStack {
                    TextField("Neue Nachricht", text: $newMessage)
                        .onChange(of: newMessage) { newValue, _ in
                            if newValue.count > 500 {
                                newMessage = String(newValue.prefix(500))
                            }
                        }
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled()
                        .padding(0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.cyan, lineWidth: 2)
                        )
                        .keyboardType(.default)
                        .submitLabel(.done)
                    ButtonTextAction(iconName: "paperplane", text: "Senden") {
                        if !newMessage.isEmpty {
                            chatVm.createNewMessage(userName: userName, messageText: newMessage, isLiked: false, isLikedByUser: [], profileImage: authVm.user?.imageUrl)
                            newMessage = ""
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                        }
                    }
                }
                .padding(
                    EdgeInsets(
                        top: 0,
                        leading: 10,
                        bottom: 10,
                        trailing: 10))
                Divider()
            }
            .navigationBarTitle("Mein Campfire", displayMode: .inline)
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
                    .ignoresSafeArea()
            )
        }
        .onAppear {
            chatManager.readExcludedUserList()
            chatVm.readMessages()
            authVm.user?.timeStampLastVisitChat = Date.now
        }
        .onDisappear {
            authVm.updateUser()
            chatVm.removeListener()
            chatManager.removeListener()
        }
        .searchable(text: Binding(
            get: { chatVm.searchTerm },
            set: { chatVm.searchTerm = $0.lowercased() }
        ))
        .background(Color(UIColor.systemBackground))
        .popover(isPresented: $showReactionPopover) {
            ReactionPopover(selectedChatSenderViewModel: $selectedChatSenderViewModel, chatVm: chatVm)
                .presentationCompactAdaptation(.popover)
                .background(Color.primary)
        }
    }
}

#Preview {
    let chatVm = ChatScreenViewModel(user: UserModel(id: "1", email: "1", registeredTime: Date(), userName: "hallo", timeStampLastVisitChat: Date.now, isActive: true, imageUrl: ""))
    return ChatScreenView(chatVm: chatVm)
        .environmentObject(AuthViewModel())
}
