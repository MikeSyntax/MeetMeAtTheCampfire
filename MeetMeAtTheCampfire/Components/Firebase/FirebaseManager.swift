//
//  FirebaseManager.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 29.02.24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct FirebaseManager {
    //Erstellen einer singelten static let für den Manager um überall in der App auf Firebase zuzugreifen
    static let shared = FirebaseManager()
    
    
    let authentication = Auth.auth()
    let firestore = Firestore.firestore()
    let storage = Storage.storage()
    
    //Anlegen einer Variablen "userId" mit dem Authentication-CurrentUser-UID
    var userId: String? {
        authentication.currentUser?.uid
    }
}
