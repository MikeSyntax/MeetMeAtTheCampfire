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
    //Counter für den .badge im MainScreen
    var messageCountResult: Int = 0
    //der Listener muss beim Logout auch wieder auf nil gesetzt werden
    private var listener: ListenerRegistration? = nil
    //Search in Chat
    @Published var chatMessages: [ChatSenderViewModel] = []
    @Published var searchTerm: String = ""
    
    var user: UserModel
    
    init(user: UserModel){
        self.user = user
    }
    
    deinit{
        removeListener()
    }
    
    //Search in Chat
    func searchMessages(for searchTerm: String) -> [String] {
        // Durchsuche die Nachrichten nach dem Suchbegriff und gib die IDs zurück
        let matchingMessages = chatMessages.filter { $0.messageText.contains(searchTerm) }
        print("Matching Messages \(matchingMessages.count)")
        return matchingMessages.map { $0.chatSenderVm.id ?? "Keine Nachricht" } // Hier wird die ID direkt aus dem ChatModel extrahiert
    }
    
    //MARK Anlegen aller 4 CRUD Operationen Create Read Update und Delete ------------------------------------------------------------------
    //Neue ChatNachricht im Firestore anlegen
    func createNewMessage(userName: String, messageText: String){
        guard let userId = FirebaseManager.shared.userId else {
            return
        }
        
        let message = ChatModel(userId: userId, userName: userName, messageText: messageText, timeStamp: Date(), isReadbyUser: [userId])
        
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
                //Anzahl ungelesener Nachrichten ermitteln um den .badge anzuzeigen
                let counter = chatSenderViewModels.filter { !$0.chatSenderVm.isReadbyUser.contains(userId) }.count
                print("new email counter \(counter)")
                self.messageCountResult = counter
            }
    }
    
    func updateisReadStatus(chatSenderVm: ChatSenderViewModel) {
        guard let messageId = chatSenderVm.chatSenderVm.id else {
            return
        }
        
        guard let userId = user.id else {
            return
        }
        
        //zuerst zur Liste die neue Id hinzufügen
        chatSenderVm.isReadbyUser.append(userId)
        //hier dann nur die neue Liste übergeben
        let newData = ["isReadbyUser": chatSenderVm.isReadbyUser]
        
        FirebaseManager.shared.firestore.collection("messages").document(messageId).updateData(newData) { error in
            if let error = error {
                print("Updating isRead status failed: \(error)")
            } else {
                print("isRead update done")
            }
        }
    }
    
    func removeListener(){
        self.listener = nil
        self.chatSenderViewModels = []
    }
}

