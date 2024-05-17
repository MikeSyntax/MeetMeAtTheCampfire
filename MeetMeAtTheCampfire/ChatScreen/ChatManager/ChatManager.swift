//
//  ChatManager.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 15.05.24.
//

//import Foundation
//
//final class ChatManager: ObservableObject {
//    
//    @Published var startListExcludedUser: Int = 0
//    
//    static var shared = ChatManager()
//    private init() { }
//    var excludedUserIds: Set<String> = []
//    
//    func toogleExcludedUserId(_ userId: String){
//        if excludedUserIds.contains(userId){
//            excludedUserIds.remove(userId)
//            startListExcludedUser -= 1
//        } else {
//            excludedUserIds.insert(userId)
//            startListExcludedUser += 1
//        }
//    }
//}
