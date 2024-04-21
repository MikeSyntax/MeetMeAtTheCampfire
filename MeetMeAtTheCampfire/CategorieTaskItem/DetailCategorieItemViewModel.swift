//
//  CategorieTaskItemViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 13.03.24.
//

import Foundation

class CategorieTaskItemViewModel: ObservableObject {
    @Published var taskName: String = ""
    @Published var taskIsDone: Bool = false
    
    let categorieTaskItemModel: TaskModel
    
    init(categorieTaskItemModel: TaskModel){
        self.categorieTaskItemModel = categorieTaskItemModel.self
        self.taskName = categorieTaskItemModel.taskName
        self.taskIsDone = categorieTaskItemModel.taskIsDone
    }
}
