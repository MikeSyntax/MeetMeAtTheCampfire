//
//  CategorieViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 04.03.24.
//

import Foundation

class CategorieViewModel: ObservableObject, Identifiable {
    
    @Published var categorie = "Tasks"
    @Published var tasksInCategorie = 4
    @Published var isDone = false
    
    
    let categorieViewModel: CategorieModel
    
    init(categorieDesign: CategorieModel){
        self.categorieViewModel = categorieDesign.self
        self.categorie = categorieDesign.categorieName
        self.isDone = categorieDesign.isDone
        self.tasksInCategorie = categorieDesign.tasksInCategorie
     
    }
}
