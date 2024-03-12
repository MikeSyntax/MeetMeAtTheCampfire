//
//  CategorieModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 04.03.24.
//

import Foundation
import FirebaseFirestoreSwift

struct CategorieModel: Codable, Identifiable {
    @DocumentID var id: String?
    
    let userId: String
    let categorieName: String
    let isDone: Bool
    let tasksInCategorie: Int
}

