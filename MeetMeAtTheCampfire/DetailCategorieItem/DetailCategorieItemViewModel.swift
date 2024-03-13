//
//  DetailCategorieItemViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 13.03.24.
//

import Foundation

class DetailCategorieItemViewModel: ObservableObject {
    @Published var taskName: String = "Essen besstellen"
    @Published var taskIsDone: Bool = true
    
    let detailCategorieItemModel: TaskModel
    
    init(detailCategorieItemModel: TaskModel){
        self.detailCategorieItemModel = detailCategorieItemModel.self
        self.taskName = detailCategorieItemModel.taskName
        self.taskIsDone = detailCategorieItemModel.taskIsDone
    }
}
