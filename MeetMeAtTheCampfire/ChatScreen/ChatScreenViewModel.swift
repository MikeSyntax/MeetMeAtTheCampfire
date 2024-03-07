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
    
    
    init(){
        // Liste mit DummyDaten an Nachrichten für die erste Anzeige
        chatSenderViewModels = [
            ChatSenderViewModel(chatDesign: ChatModel(userId: "1", userName: "Dieter", messageText: "Huhu", timeStamp: Date())),
            ChatSenderViewModel(chatDesign: ChatModel(userId: "2", userName: "Tamara", messageText: "Wieviel Geld sollte ich mitnehmen", timeStamp: Date())),
            ChatSenderViewModel(chatDesign: ChatModel(userId: "3", userName: "Klaus", messageText: "Das kommt ganz darauf an, wie lange du bleiben willst", timeStamp: Date()))]
    }
    
    //der Listener muss beim Logout auch wieder auf nil gesetzt werden
    private var listener: ListenerRegistration? = nil
    
    //MARK Anlegen aller 4 CRUD Operationen Create Read Update und Delete ------------------------------------------------------------------
    
    //Neue ChatNachricht im Firestore anlegen
    func createNewMessage(userName: String, messageText: String){
        guard let userId = FirebaseManager.shared.userId else {
            return
        }
        
        let message = ChatModel(userId: userId, userName: userName, messageText: messageText, timeStamp: Date())
        
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
            }
    }
    
    func removeListener(){
        self.listener = nil
        self.chatSenderViewModels = []
    }
}


