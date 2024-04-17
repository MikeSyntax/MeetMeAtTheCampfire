//
//  LogBookModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 20.03.24.
//

import Foundation
import FirebaseFirestoreSwift

struct LogBookModel: Codable, Identifiable, Equatable, Hashable {
    @DocumentID var id: String?
    
    //Zuordnung des Eintrags
    let userId: String
    let formattedDate: String
    let logBookText: String
    
    //Zuordnung der Position des Eintrags
    let latitude: Double
    let longitude: Double
    
    let imageUrl: String
    let containsLogBookEntry: Bool
}
