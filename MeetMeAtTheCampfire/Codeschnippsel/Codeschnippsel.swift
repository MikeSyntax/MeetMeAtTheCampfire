//
//  Codeschnippsel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 08.03.24.
//

import Foundation

// self.newMessagesCount = self.checkForNewMessages(from: chatSenderViewModels)

//    func updateReadStatus(chatSenderVm: ChatSenderViewModel){
//        guard let messageId = chatSenderVm.chatSenderVm.id else {
//            return
//        }
//
//        guard let index = chatSenderViewModels.firstIndex(where: { $0.chatSenderVm.id == messageId }) else {
//            return
//        }
//
//        let updatedReadStatus = [
//            "isRead" : chatSenderVm.isRead ? false : true]
//
//        FirebaseManager.shared.firestore.collection("messages").document(messageId).setData(updatedReadStatus, merge: true){
//            error in
//            if let error {
//                print("updating readStatus failed: \(error)")
//            } else {
//                print("update succeeded")
//            }
//        }
//    }
//
//    //Funktion um Nachrichten als gelesen zu markieren
//    func markMessageAsRead(messageId: String) {
//        guard let index = chatSenderViewModels.firstIndex(where: { $0.chatSenderVm.id == messageId }) else {
//            return
//        }
//        chatSenderViewModels[index].isRead = true
//    }
//
//    //mit dem aktuellen Timestamp die Anzahl der neuen Nachrichten ermitteln
//    private func checkForNewMessages(from chatSenderViewModels: [ChatSenderViewModel]) -> Int {
//        return chatSenderViewModels.filter { !$0.isRead }.count
//    }

