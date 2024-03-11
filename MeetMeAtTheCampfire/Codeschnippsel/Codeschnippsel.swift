//
//  Codeschnippsel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 08.03.24.
//

import Foundation

//Beim Chat die Box automatisch der Nachricht anpassen
//Beim Einloggen muss man manchmal erst zwischen den Screen wechseln bevor sich die Ansicht aktualisiert
//Die Sprache aus dem Picker wird nicht geändert. ERLEDIGT
//Die Suche im Chat soll an einen bestimmten chat springen, wenn es geht
//Die Nachrichten in eine eigene Variable speichern und dann mit dem Array vergleichen und somit das Badge aktuell


//
//    //mit dem aktuellen Timestamp die Anzahl der neuen Nachrichten ermitteln
//    private func checkForNewMessages(from chatSenderViewModels: [ChatSenderViewModel]) -> Int {
//        return chatSenderViewModels.filter { !$0.isRead }.count
//    }

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
