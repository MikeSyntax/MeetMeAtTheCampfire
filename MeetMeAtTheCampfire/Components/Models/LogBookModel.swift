//
//  LogBookModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 20.03.24.
//

import Foundation
import FirebaseFirestoreSwift

struct LogBookModel: Codable, Identifiable {
    @DocumentID var id: String?
    
    //Zuordnung des Eintrags
    let userId: String
    let formattedDate: String
    let logBookText: String
    
    //Zuordnung der Position des Eintrags
    let laditude: Double
    let longitude: Double
}
