//
//  DetailCategorieItemViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 13.03.24.
//

import Foundation

@MainActor
final class DetailCategorieItemViewModel: ObservableObject {
    @Published var taskName: String = ""
    @Published var taskIsDone: Bool = false
    
    let detailCategorieItemModel: TaskModel
    
    init(detailCategorieItemModel: TaskModel){
        self.detailCategorieItemModel = detailCategorieItemModel.self
        self.taskName = detailCategorieItemModel.taskName
        self.taskIsDone = detailCategorieItemModel.taskIsDone
    }
}
