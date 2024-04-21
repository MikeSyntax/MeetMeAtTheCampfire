//
//  ProfileScreenViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 20.04.24.
//

import Foundation
import FirebaseFirestore

class ProfileScreenViewModel: ObservableObject {
    
    @Published var chatLikedViewModels: [ChatItemViewModel] = []
    //Counter für den .badge im MainScreen
    var messageCountResult: Int = 0
    private var listener: ListenerRegistration? = nil
    @Published var searchTerm: String = ""
    var user: UserModel
    
    init(user: UserModel){
        self.user = user
    }
    
    deinit{
        removeListener()
    }
    
    //Lesen aller Nachrichten aus dem Firestore
    func readLikedMessages() {
        guard let userId = FirebaseManager.shared.userId else {
            return
        }
        
        self.listener = FirebaseManager.shared.firestore.collection("messages")
            .whereField("isLikedByUser", arrayContains: userId)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error reading likedMessages: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("Query Snapshot likedMessages is empty")
                    return
                }
                
                let messages = documents.compactMap { document in
                    try? document.data(as: ChatModel.self)
                }
                let sortedMessages = messages.sorted { $0.timeStamp < $1.timeStamp }
                
                let chatLikedViewModels = sortedMessages.map { message in
                    return ChatItemViewModel(chatDesign: message)
                }
                self.chatLikedViewModels = chatLikedViewModels
            }
    }
    
    func removeListener(){
        self.listener = nil
        self.chatLikedViewModels = []
    }
}
