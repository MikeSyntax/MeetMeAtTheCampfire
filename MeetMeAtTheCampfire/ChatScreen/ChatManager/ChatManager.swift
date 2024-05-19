//
//  ChatManager.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 19.05.24.
//

import Foundation
import FirebaseFirestore

@MainActor
final class ChatManager: ObservableObject {
    
    @Published var excludedUserIds: [String] = []
    
    static var shared = ChatManager()
    private init() { }
    
    private var listener: ListenerRegistration? = nil
    
    func addExcludedUserId(_ userId: String) {
        guard let currentUser = FirebaseManager.shared.authentication.currentUser?.uid else {
            print("ChatManager no UserId found")
            return
        }
        if !excludedUserIds.contains(userId){
            excludedUserIds.append(userId)
        }
        let result = ["excludedUserIds" : excludedUserIds]
        
        if !userId.isEmpty {
            do{  FirebaseManager.shared.firestore.collection("blockedUser").document(currentUser)
                    .setData(result) { error in
                        if let error = error {
                            print("Append excludedUserIds failed: \(error)")
                        } else {
                            print("Append excludedUserIds done")
                        }
                    }
            }
        }
    }
    
    func removeExcludedUserId(_ userId: String) {
        guard let currentUser = FirebaseManager.shared.authentication.currentUser?.uid else {
            print("ChatManager no UserId found")
            return
        }
        if excludedUserIds.contains(userId){
            excludedUserIds.removeAll(where: { $0 == userId })
        }
        let result = ["excludedUserIds" : excludedUserIds]
        
        if !userId.isEmpty {
            do{  FirebaseManager.shared.firestore.collection("blockedUser").document(currentUser)
                    .setData(result) { error in
                        if let error = error {
                            print("Remove excludedUserIds failed: \(error)")
                        } else {
                            print("Remove excludedUserIds done")
                        }
                    }
            }
        }
    }
    
    func readExcludedUserList() {
        guard let currentUser = FirebaseManager.shared.authentication.currentUser?.uid else {
            print("ChatManager no UserId found")
            return
        }
        self.listener = FirebaseManager.shared.firestore.collection("blockedUser").document(currentUser)
            .addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    print("Not able to read Excluded UserIds: \(error)")
                    return
                }
                guard let document = documentSnapshot else {
                    print("No document found for blockedUser")
                    return
                }
                let data = document.data()
                self.excludedUserIds = data?["excludedUserIds"] as? [String] ?? []
            }
    }
    
    func removeListener(){
        listener = nil
    }
}

