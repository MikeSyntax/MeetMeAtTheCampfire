//
//  ChatItemViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 07.03.24.
//

import Foundation

//Hier werden verschiedene Protokolle implementiert unter anderen das Equatable Protokoll (Vergleichsprotokoll)
final class ChatItemViewModel: ObservableObject, Identifiable, Equatable {
    //mit dieser static Funktion wird es ermöglicht Instanzen dieser Klasse zu vergleichen in diesem Fall die id´s der ChatSenderViewModels und es wird eine true oder false zurückgegeben
    static func == (chatReceiver: ChatItemViewModel, chatSender: ChatItemViewModel) -> Bool {
        return chatReceiver.id == chatSender.id
    }
    
    @Published var userName: String = ""
    @Published var messageText: String = ""
    @Published var dateString: String = ""
    @Published var isCurrentUser: Bool = false
    @Published var isReadbyUser: [String] = []
    @Published var userId: String = ""
    @Published var isLiked: Bool
    @Published var isLikedByUser: [String] = []
    @Published var profileImage: String? = ""
    @Published var timeStamp = Date()
    
    // Eine Konstante 'chatSenderVm' vom Typ 'ChatModel', die die Daten des Chatmodells enthält.
    let chatSenderVm: ChatModel
    
    // Initialisierungsmethode, die ein ChatModel-Objekt und optionalen Parameter 'isCurrentUser' erhält.
    init(chatDesign: ChatModel, isCurrentUser: Bool = false) {
        // Zuweisung des übergebenen ChatModel-Objekts an die 'chatSenderVm'-Variable.
        self.chatSenderVm = chatDesign
        self.userName = chatDesign.userName
        self.timeStamp = chatDesign.timeStamp
        self.messageText = chatDesign.messageText
        self.isReadbyUser = chatDesign.isReadbyUser
        self.userId = chatDesign.userId
        self.isLiked = chatDesign.isLiked
        self.isLikedByUser = chatDesign.isLikedByUser
        self.isCurrentUser = isCurrentUser
        self.profileImage = chatDesign.profileImage
        
        updateDate()
    }
    
    func updateDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        self.dateString = formatter.string(from: timeStamp)
    }
    
    @MainActor
    func updateIsLikedStatus(chatSenderVm: ChatItemViewModel) {
        guard let messageId = chatSenderVm.chatSenderVm.id else {
            return
        }
        guard let userId = FirebaseManager.shared.userId else {
            return
        }
        // check for user like
        let isLikedByUser = chatSenderVm.isLikedByUser.contains(userId)
        // add or remove Arry
        if isLikedByUser {
            if let index = chatSenderVm.isLikedByUser.firstIndex(of: userId) {
                chatSenderVm.isLikedByUser.remove(at: index)
            }
        } else {
            chatSenderVm.isLikedByUser.append(userId)
        }
        let messagesBox: [String: Any] = ["isLiked": !chatSenderVm.isLikedByUser.isEmpty,
                                          "isLikedByUser": chatSenderVm.isLikedByUser]
        FirebaseManager.shared.firestore.collection("messages")
            .document(messageId)
            .updateData(messagesBox) { error in
            if let error = error {
                print("update isLikedStatus failed: \(error)")
            } else {
                print("update isLikedStatus done")
            }
        }
    }
}
