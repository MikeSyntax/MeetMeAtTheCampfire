//
//  DetailCategorieViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 13.03.24.
//

import Foundation
import FirebaseFirestore

class DetailCategorieViewModel: ObservableObject {
    
    @Published var detailCategorieItemViewModels: [DetailCategorieItemViewModel] = []
    private var listener: ListenerRegistration? = nil
    
    init(){
        detailCategorieItemViewModels = [
            
        DetailCategorieItemViewModel(detailCategorieItemModel: TaskModel(userId: "1", taskName: "Essen", taskIsDone:  false)),
        DetailCategorieItemViewModel(detailCategorieItemModel: TaskModel(userId: "1", taskName: "Trinken", taskIsDone:  false)),
        DetailCategorieItemViewModel(detailCategorieItemModel: TaskModel(userId: "1", taskName: "Tanzen", taskIsDone:  true))
        ]
        
        
    }
}
