//
//  ChatScreenViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 07.03.24.
//

import Foundation
import FirebaseFirestore

class ChatScreenViewModel: ObservableObject {
    
    //Leere Liste erzeugt
    @Published var chatSenderViewModels: [ChatSenderViewModel] = []
    @Published var messagesCountResult: Int = 0
    @Published var messageCountNew: Int = 0
    @Published var messageCountOld: Int = 0
    @Published var messageCountOldFromUserFirebase: Int = 0
    
    init(){
        // Liste mit DummyDaten an Nachrichten für die erste Anzeige
        chatSenderViewModels = [
            ChatSenderViewModel(chatDesign:
                                    ChatModel(userId: "1", userName: "Dieter", messageText: "Huhu", timeStamp: Date(), isRead: false)),
            ChatSenderViewModel(chatDesign:
                                    ChatModel(userId: "2", userName: "Tamara", messageText: "Wieviel Geld sollte ich mitnehmen", timeStamp: Date(), isRead: false)),
            ChatSenderViewModel(chatDesign:
                                    ChatModel(userId: "3", userName: "Klaus", messageText: "Das kommt ganz darauf an, wie lange du bleiben willst", timeStamp: Date(), isRead: false))
        ]
    }
    
    deinit{
        removeListener()
    }
    
    //der Listener muss beim Logout auch wieder auf nil gesetzt werden
    private var listener: ListenerRegistration? = nil
    
    //MARK Anlegen aller 4 CRUD Operationen Create Read Update und Delete ------------------------------------------------------------------
    //Neue ChatNachricht im Firestore anlegen
    func createNewMessage(userName: String, messageText: String, isRead: Bool){
        guard let userId = FirebaseManager.shared.userId else {
            return
        }
        
        let message = ChatModel(userId: userId, userName: userName, messageText: messageText, timeStamp: Date(), isRead: isRead)
        
        do{
            try FirebaseManager.shared.firestore.collection("messages").addDocument(from: message)
        } catch {
            print("Error creating new message: \(error)")
        }
    }
    
    //Lesen aller Nachrichten aus dem Firestore
    func readMessages() {
        guard let userId = FirebaseManager.shared.userId else {
            return
        }
        
        self.listener = FirebaseManager.shared.firestore.collection("messages")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error reading messages: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("Query Snapshot is empty")
                    return
                }
                
                let messages = documents.compactMap { document in
                    try? document.data(as: ChatModel.self)
                }
                let sortedMessages = messages.sorted { $0.timeStamp < $1.timeStamp }
                
                let chatSenderViewModels = sortedMessages.map { message in
                    let isCurrentUser = message.userId == userId // Überprüfen, ob der Absender der eingeloggte Benutzer ist
                    return ChatSenderViewModel(chatDesign: message, isCurrentUser: isCurrentUser)
                }
                self.chatSenderViewModels = chatSenderViewModels
                
                //Alle Nachrichten zählen
 //               self.setMessageCountOld()
            }
    }
    
    func updateisReadStatus(chatSenderVm: ChatSenderViewModel){
        guard let messageId = chatSenderVm.chatSenderVm.id else {
            return
        }
        
        let updatedReadStatus = [
            "isRead" : chatSenderVm.chatSenderVm.isRead ? false : true]
        
        FirebaseManager.shared.firestore.collection("messages").document(messageId).setData(updatedReadStatus, merge: true){
            error in
            if let error {
                print("updating isRead - Status failed: \(error)")
            } else {
                print("chat isRead - update done")
            }
        }
    }
    
    func removeListener(){
        self.listener = nil
        self.chatSenderViewModels = []
    }
    
//    //MARK - Zählerstand für den Badge auf der Startseite des Chats für die ungelesenen Nachrichten.--------------------------------------------------
//    
//    
//    //Den neuen Zähler minus den alten Zähler ergibt das Result für die Badge Anzeige
//    func getNewMessageCount(){
//        messagesCountResult = messageCountNew - messageCountOldFromUserFirebase
//        print("Result \(messagesCountResult) = messageCountNew \(messageCountNew) - messageCountOldFromFirebase \(messageCountOldFromUserFirebase)")
//    }
//    
//    //Den Zähler auf die anzahl der Nachrichten beim letzten Besuch des Chats setzen
//    func setMessageCountOld() {
//        print("chatSenderViewModels.count old beim betreten des Chats:   \(chatSenderViewModels.count)")
//        messageCountOld = chatSenderViewModels.count
//    }
//    
//    //Den neuen Zähler setzen
//    func setMessageCountNew() {
//        print("chatSenderViewModels.count new nach erneutem Einloggen:   \(chatSenderViewModels.count)")
//        messageCountNew = chatSenderViewModels.count
//    }
//    
//    //Zähler der alten Messages persistent speichern
//    func createMessageCountOld(){
//        guard let userId = FirebaseManager.shared.userId else {
//            return
//        }
//        
//        let count = MessageCountModel(userId: userId, messageCountOld: messageCountOld)
//        
//        do{
//            try FirebaseManager.shared.firestore.collection("messageCount").addDocument(from: count)
//        } catch {
//            print("Error creating new messageCount: \(error)")
//        }
//    }
//    
//    //Lesen der letzten gespeicherten Anzahl aller Nachrichten eines bestimmten Users
//    func readMessageCount() {
//        guard let userId = FirebaseManager.shared.userId else {
//            return
//        }
//        
//        self.listener = FirebaseManager.shared.firestore.collection("messageCount")
//            .addSnapshotListener { querySnapshot, error in
//                if let error = error {
//                    print("Error reading messageCount: \(error)")
//                    return
//                }
//                
//                guard let documents = querySnapshot?.documents else {
//                    print("Query Snapshot is empty")
//                    return
//                }
//                
//                let counts = documents.compactMap { document in
//                    try? document.data(as: MessageCountModel.self)
//                }
//                
//                // Sortiere die counts nach userId
//                let sortedCounts = counts.sorted { $0.userId < $1.userId }
//                
//                // Finde den messageCountOld für den aktuellen Benutzer
//                if let userCount = sortedCounts.first(where: { $0.userId == userId }) {
//                    self.messageCountOldFromUserFirebase = userCount.messageCountOld
//                    print("Saved messageCountOldFromFirebase from Firebase:  \(self.messageCountOldFromUserFirebase)")
//                } else {
//                    print("No messageCountOld for user: \(userId) found.")
//                }
//            }
//    }
}
//
