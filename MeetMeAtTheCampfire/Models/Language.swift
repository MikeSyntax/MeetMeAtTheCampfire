//
//  Language.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 08.03.24.
//

import Foundation

struct LanguageResult: Codable {
    let data: LanguageData
}

struct LanguageData: Codable, Hashable {
    let languages: [Language]
}

struct Language: Codable, Hashable {
    let code: String
    var name: String
}
