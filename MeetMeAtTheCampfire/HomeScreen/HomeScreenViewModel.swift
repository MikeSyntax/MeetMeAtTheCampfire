//
//  HomeScreenViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 04.03.24.
//

import Foundation
import FirebaseFirestore
import UIKit

@MainActor
final class HomeScreenViewModel: ObservableObject {
    
   
    @Published var categorieViewModels: [CategorieViewModel] = []
    private var listener: ListenerRegistration? = nil
    
    //MARK Anlegen aller 4 CRUD Operationen Create Read Update und Delete ------------------------------------------------------------------
    
    func createCategorie(categorieName: String){
        guard let userId = FirebaseManager.shared.userId else {
            return
        }
        let categorie = CategorieModel(userId: userId, categorieName: categorieName, isDone: false, tasksInCategorie: 0)
        do{
            try FirebaseManager.shared.firestore.collection("categories").addDocument(from: categorie)
        } catch {
            print("Error creating new categorie: \(error)")
        }
    }
    
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
            let sortedCategories = categories.sorted { $0.categorieName < $1.categorieName }
            let categorieViewModels = sortedCategories.map { CategorieViewModel(categorieDesign: $0) }
            self.categorieViewModels = categorieViewModels }
        
    }
    
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
    
    func triggerSuccessVibration() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
    }
    
    func removeListener(){
        self.listener = nil
        self.categorieViewModels = []
    }
}
