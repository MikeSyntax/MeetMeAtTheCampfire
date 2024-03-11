//
//  MessageCountModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 11.03.24.
//

import Foundation
import Foundation
import FirebaseFirestoreSwift

struct MessageCountModel: Codable, Identifiable {
    @DocumentID var id: String?
    
    let userId: String
    let messageCountOld: Int
    
}
