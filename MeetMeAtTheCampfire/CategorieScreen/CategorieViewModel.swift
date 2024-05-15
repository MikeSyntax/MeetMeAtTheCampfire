//
//  CategorieViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 04.03.24.
//

import Foundation

@MainActor
final class CategorieViewModel: ObservableObject, Identifiable {
    
    @Published var categorie = "Tasks"
    @Published var tasksInCategorie = 0
    @Published var isDone = false
    
    
    let categorieViewModel: CategorieModel
    
    init(categorieDesign: CategorieModel){
        self.categorieViewModel = categorieDesign.self
        self.categorie = categorieDesign.categorieName
        self.isDone = categorieDesign.isDone
        self.tasksInCategorie = categorieDesign.tasksInCategorie
    }
    
    func updateTaskCounter(tasksInCategorie: Int){
        self.tasksInCategorie = tasksInCategorie
    }
}
