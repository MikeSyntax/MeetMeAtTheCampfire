//
//  LogBookActivity.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 08.05.24.
//

import Foundation
import SwiftData

@Model
final class LogBookAtivity: Identifiable {
    
    var id: String
    var date: Date
    var isNotEmpty: Bool
    var userId: String
    
    init(date: Date, isNotEmpty: Bool, userId: String){
        
        self.id = UUID().uuidString
        self.userId = userId
        self.date = date
        self.isNotEmpty = isNotEmpty
    }
}
