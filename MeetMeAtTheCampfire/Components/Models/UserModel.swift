//
//  UserModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 29.02.24.
//

import Foundation

struct UserModel: Codable, Identifiable {
    
    let id: String?
    let email: String
    let registeredTime: Date
    let userName: String
    var timeStampLastVisitChat: Date
    var isActive: Bool
    var imageUrl: String
}
