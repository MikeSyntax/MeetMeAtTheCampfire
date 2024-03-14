//
//  TaskModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 13.03.24.
//

import Foundation
import FirebaseFirestoreSwift

struct TaskModel: Codable, Identifiable {
    @DocumentID var id: String?
    
    let categorieId: String
    let taskName: String
    let taskIsDone: Bool
    
}
