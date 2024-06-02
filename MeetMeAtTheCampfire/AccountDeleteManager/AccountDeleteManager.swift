//
//  AccountDeleteManager.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 02.06.24.
//

import Foundation

@MainActor
final class AccountDeleteManager {
    
    static var shared = AccountDeleteManager()
    
    private init(){}
    
    func deleteAllMessagesWithId(completion: @escaping () -> Void) {
        guard let userId = FirebaseManager.shared.userId else {
            return
        }
        
        let refUserIdData = FirebaseManager.shared.firestore.collection("messages")
        let userMessagesToDelete = refUserIdData.whereField("userId", isEqualTo: userId)
        
        userMessagesToDelete.getDocuments {
            (querySnapshot, error) in
            if let error = error {
                print("error getting message documents: \(error)")
                completion()
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("no message documents found")
                completion()
                return
            }
            
            let batch = FirebaseManager.shared.firestore.batch()
            
            for document in documents {
                //uses a batch for this collection to delete all messages up to 500 units, no more
                batch.deleteDocument(document.reference)
            }
            
            batch.commit { error in
                if let error = error {
                    print("Error deleting message documents: \(error)")
                } else {
                    print("All user messages deleted")
                }
                completion()
            }
        }
    }
    
    func deleteAllCategoriesWithId(completion: @escaping () -> Void) {
        guard let userId = FirebaseManager.shared.userId else {
            return
        }
        
        let refUserIdData = FirebaseManager.shared.firestore.collection("categories")
        let userMessagesToDelete = refUserIdData.whereField("userId", isEqualTo: userId)
        
        userMessagesToDelete.getDocuments {
            (querySnapshot, error) in
            if let error = error {
                print("error getting categorie documents: \(error)")
                completion()
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("no categorie documents found")
                completion()
                return
            }
            
            let batch = FirebaseManager.shared.firestore.batch()
            
            for document in documents {
                batch.deleteDocument(document.reference)
            }
            
            batch.commit { error in
                if let error = error {
                    print("Error deleting categorie documents: \(error)")
                } else {
                    print("All user categories deleted")
                }
                completion()
            }
        }
    }
    
    func deleteAllNewLogEntriesWithId(completion: @escaping () -> Void) {
        guard let userId = FirebaseManager.shared.userId else {
            return
        }
        
        let refUserIdData = FirebaseManager.shared.firestore.collection("newLogEntry")
        let userMessagesToDelete = refUserIdData.whereField("userId", isEqualTo: userId)
        
        userMessagesToDelete.getDocuments {
            (querySnapshot, error) in
            if let error = error {
                print("error getting newLogEntry documents: \(error)")
                completion()
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("no newLogEntry documents found")
                completion()
                return
            }
            
            let batch = FirebaseManager.shared.firestore.batch()
            
            for document in documents {
                batch.deleteDocument(document.reference)
            }
            
            batch.commit { error in
                if let error = error {
                    print("Error deleting newLogEntry documents: \(error)")
                } else {
                    print("All user newLogEntries deleted")
                }
                completion()
            }
        }
    }
    
    func deleteUserData(completion: @escaping () -> Void) {
        guard let currentUser = FirebaseManager.shared.userId else {
            return
        }
        FirebaseManager.shared.firestore.collection("appUser")
            .document(currentUser).delete(){ error in
                if error == nil {
                    completion()
                }
            }
    }
    
    func deleteAccount(completion: @escaping () -> Void) {
        guard let currentUserId = FirebaseManager.shared.authentication.currentUser else {
            return
        }
        currentUserId.delete(){ error in
            if error == nil {
                completion()
            }
        }
    }
}
