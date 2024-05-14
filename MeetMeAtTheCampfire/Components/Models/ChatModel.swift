//
//  ChatModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 07.03.24.
//

import Foundation
import FirebaseFirestoreSwift

struct ChatModel: Codable, Identifiable {
    @DocumentID var id: String?
    
    let userId: String
    let userName: String
    let messageText: String
    let timeStamp: Date
    let isReadbyUser: [String]
    var isLiked: Bool
    let isLikedByUser: [String]
    let profileImage: String?
    
    //um den TimeStamp überall zugänglich zu machen
    func getTimeStamp() -> Date {
            return timeStamp
        }
}

