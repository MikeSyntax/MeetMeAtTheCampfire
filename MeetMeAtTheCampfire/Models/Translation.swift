//
//  Translation.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 09.03.24.
//

import Foundation

struct Translation: Codable {
    let status: String
    let data: GetTranslation
}

struct GetTranslation: Codable {
    let translatedText: String
}
