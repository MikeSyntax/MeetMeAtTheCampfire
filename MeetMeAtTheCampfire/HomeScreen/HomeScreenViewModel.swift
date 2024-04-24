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
    @Published var categorieViewModels: [CategorieViewModel] = []
    
    //der Listener muss beim Logout auch wieder auf nil gesetzt werden
    private var listener: ListenerRegistration? = nil
    
    //MARK Anlegen aller 4 CRUD Operationen Create Read Update und Delete ------------------------------------------------------------------
    
    deinit{
        removeListener()
    }
    //Anlegen einer neuen Kategorie im Firebase Firestore
    @MainActor
    func createCategorie(categorieName: String){
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
    @MainActor
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
            
            let categorieViewModels = categories.map { CategorieViewModel(categorieDesign: $0) }
            self.categorieViewModels = categorieViewModels }
        
    }
    
    //Änderungen an der Kategorie vornehmen, in diesem Fall Kategorie ist erledigt
    @MainActor
    func updateCategorie(categorieVm: CategorieViewModel){
        guard let categorieId = categorieVm.categorieViewModel.id else {
            return
        }
        
        let updatedCategorie = [
            "isDone" : categorieVm.isDone ? false : true]
        
        FirebaseManager.shared.firestore.collection("categories").document(categorieId).setData(updatedCategorie, merge: true) {
            error in
            if let error {
                print("update categorie failed: \(error)")
            } else {
                print("update categorie done")
            }
        }
    }
    
    //Löschen einer Kategorie
    @MainActor
    func deleteCategorie(categorieVm: CategorieViewModel){
        guard let categorieId = categorieVm.categorieViewModel.id else {
            return
        }
        
        FirebaseManager.shared.firestore.collection("categories").document(categorieId).delete() { error in
            if let error {
                print("deleting categorie failed \(error)")
            } else {
                print("delete categorie succeeded")
            }
        }
    }
    
    func removeListener(){
        self.listener = nil
        self.categorieViewModels = []
    }
}
