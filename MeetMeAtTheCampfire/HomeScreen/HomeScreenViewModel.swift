//
//  HomeScreenViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 04.03.24.
//

import Foundation
import FirebaseFirestore

class HomeScreenViewModel: ObservableObject {
    
    //Leere Liste an Kategorien
    @Published var categories: [CategorieModel] = []
    //der Listener muss beim Logout auch wieder auf nil gesetzt werden
    private var listener: ListenerRegistration? = nil
    
    //MARK Anlegen aller 4 CRUD Operationen Create Read Update und Delete ------------------------------------------------------------------
    
    //Anlegen einer neuen Kategorie im Firebase Firestore
    func createCategorie(categorieName: String, tasksInCategorie: Int){
        //wenn die userId leer ist mache nichts
        guard let userId = FirebaseManager.shared.userId else {
            return
        }
        
        let categorie = CategorieModel(userId: userId, categorieName: categorieName, isDone: false, tasksInCategorie: 0)
        
        do{
            //versuche im Firestore eine neue Kategorie anzulegen
            try FirebaseManager.shared.firestore.collection("categories").addDocument(from: categorie)
        } catch {
            print("Error creating new categorie: \(error)")
        }
    }
    
    //Lesen aller Kategorien aus dem Firestore
    func readCategories(){
        guard let userId = FirebaseManager.shared.userId else {
            return
        }
        
        self.listener = FirebaseManager.shared.firestore.collection("categories").whereField("userId", isEqualTo: userId).addSnapshotListener {
            querySnapshot, error in
            if let error {
                print("Error reading categories: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("Query Snapshot is empty")
                return
            }
            
            let categories = documents.compactMap { document in
                try? document.data(as: CategorieModel.self)
            }
            
            self.categories = categories
        }
    }
    
    //Zurücksetzen des Listeners und leeren des categorie Arrays bei Logout, umso zu gewährleisten, falls sich ein anderer User einloggt nicht die selbe Liste zu sehen.
    func removeListener(){
        self.listener = nil
        self.categories = []
    }
    
    //Änderungen an der Kategorie vornehmen, in diesem Fall Kategorie ist erledigt
    func updateCategorie(categorie: CategorieModel){
        guard let categorieId = categorie.id else {
            return
        }
        
        let updatedCategorie = [
            "isDone" : categorie.isDone ? false : true]
        
        FirebaseManager.shared.firestore.collection("categories").document(categorieId).setData(updatedCategorie, merge: true) {
            error in
            if let error {
                print("update categorie failed: \(error)")
            } else {
                print("update succeeded")
            }
        }
    }
    
    //Löschen einer Kategorie
    func deleteCategorie(categorie: CategorieModel){
        guard let categorieId = categorie.id else {
            return
        }
        
        FirebaseManager.shared.firestore.collection("categories").document(categorieId).delete() { error in
            if let error {
                print("deleting categorie failde \(error)")
            } else {
                print("delete succeeded")
            }
        }
    }
}
