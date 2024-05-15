//
//  ChatItemViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 07.03.24.
//

import Foundation
//Hier werden verschiedene Protokolle implementiert unter anderen das Equatable Protokoll (Vergleichsprotokoll)
@MainActor
final class ChatItemViewModel: ObservableObject, Identifiable, Equatable {
    //mit dieser static Funktion wird es ermöglicht Instanzen dieser Klasse zu vergleichen in diesem Fall die id´s der ChatSenderViewModels und es wird eine true oder false zurückgegeben
    static func == (chatReceiver: ChatItemViewModel, chatSender: ChatItemViewModel) -> Bool {
        return chatReceiver.id == chatSender.id
    }
    
    // Deklaration der Variablen mit dem Attribut '@Published', das Änderungen an dieser Variablen sofort meldet.
    @Published var userName: String = ""
    @Published var messageText: String = ""
    @Published var dateString: String = ""
    @Published var isCurrentUser: Bool = false
    @Published var isReadbyUser: [String] = []
    @Published var userId: String = ""
    @Published var isLiked: Bool
    @Published var isLikedByUser: [String] = []
    @Published var profileImage: String? = ""
    
    // Variable 'timeStamp', die das Datum und die Uhrzeit des Chatnachrichtenzeitstempels speichert.
    @Published var timeStamp = Date()
    
    // Eine Konstante 'chatSenderVm' vom Typ 'ChatModel', die die Daten des Chatmodells enthält.
    let chatSenderVm: ChatModel
    
    // Initialisierungsmethode, die ein ChatModel-Objekt und optionalen Parameter 'isCurrentUser' erhält.
    init(chatDesign: ChatModel, isCurrentUser: Bool = false) {
        // Zuweisung des übergebenen ChatModel-Objekts an die 'chatSenderVm'-Variable.
        self.chatSenderVm = chatDesign
        // Initialisierung der Instanzvariablen mit den Werten des übergebenen ChatModel-Objekts und des optionalen Parameters.
        self.userName = chatDesign.userName
        self.timeStamp = chatDesign.timeStamp
        self.messageText = chatDesign.messageText
        self.isReadbyUser = chatDesign.isReadbyUser
        self.userId = chatDesign.userId
        self.isLiked = chatDesign.isLiked
        self.isLikedByUser = chatDesign.isLikedByUser
        self.isCurrentUser = isCurrentUser
        self.profileImage = chatDesign.profileImage
        
        // Aufruf der Methode 'updateDate()', um das Datumsformat zu aktualisieren.
        updateDate()
    }
    
    // Methode, die das Datumsformat aktualisiert.
    func updateDate() {
        // Erstellung eines DateFormatter-Objekts.
        let formatter = DateFormatter()
        // Festlegung des Datumsformats für das DateFormatter-Objekt.
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        // Konvertierung des 'timeStamp' in das angegebene Datumsformat und Zuweisung an 'dateString'.
        self.dateString = formatter.string(from: timeStamp)
    }
    
    //For like chat messages change star and true or false an enter or remove id from Array of id´s
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
        
        // create array
        let messagesBox: [String: Any] = ["isLiked": !chatSenderVm.isLikedByUser.isEmpty,
                                          "isLikedByUser": chatSenderVm.isLikedByUser]
        
        // update firestore
        FirebaseManager.shared.firestore.collection("messages").document(messageId).setData(messagesBox, merge: true) { error in
            if let error = error {
                print("update isLikedStatus failed: \(error)")
            } else {
                print("update isLikedStatus done")
            }
        }
    }
}
