//
//  BlockedUser.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 16.05.24.
//

import Foundation
import SwiftData

@Model
final class BlockedUser: Identifiable {
    
    var id: String
    var userId: String
    var userName: String
    
    init(userId: String, userName: String){
        self.id = UUID().uuidString
        self.userId = userId
        self.userName = userName
    }
}
   
