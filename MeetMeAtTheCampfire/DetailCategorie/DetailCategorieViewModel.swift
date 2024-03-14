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
    @Published var tasksInCategorieCounter: Int = 0
    private var listener: ListenerRegistration? = nil
    let categorieVm: CategorieViewModel
    
    init(categorieVm: CategorieViewModel){
        self.categorieVm = CategorieViewModel(categorieDesign: CategorieModel(userId: "1", categorieName: "Putzen", isDone: false, tasksInCategorie: 2))
        
//        self.detailCategorieItemViewModels = [
//        DetailCategorieItemViewModel(detailCategorieItemModel: TaskModel(categorieId: "1", taskName: "Essen", taskIsDone:  false)),
//        DetailCategorieItemViewModel(detailCategorieItemModel: TaskModel(categorieId: "1", taskName: "Trinken", taskIsDone:  false)),
//        DetailCategorieItemViewModel(detailCategorieItemModel: TaskModel(categorieId: "1", taskName: "Tanzen", taskIsDone:  true))
//        ]
        
        self.tasksInCategorieCounter = detailCategorieItemViewModels.count
    }
    
    deinit{
        removeListener()
    }
    
    func createNewTask(taskName: String, categorieId: String?){
        guard let categorieId = categorieId else {
            return
        }
        
        let task = TaskModel(categorieId: categorieId, taskName: taskName, taskIsDone: false)
        
        do{
            try FirebaseManager.shared.firestore.collection("tasksInCategorie").addDocument(from: task)
            print("creating task succeeded")
        } catch {
            print("Error creating new task: \(error)")
        }
    }
    
    func readTasks(categorieId: String?){
        guard let categorieId = categorieId else {
            return
        }
        
        self.listener = FirebaseManager.shared.firestore.collection("tasksInCategorie").whereField("categorieId", isEqualTo: categorieId).addSnapshotListener{ querySnapshot, error in
            if let error {
                print("Error reading tasks: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("Query Snapshot is empty")
                return
            }
            
            let tasks = documents.compactMap { document in
                try? document.data(as: TaskModel.self)
            }
            
            let detailCategorieItemViewModels = tasks.map { DetailCategorieItemViewModel(detailCategorieItemModel: $0) }
            self.detailCategorieItemViewModels = detailCategorieItemViewModels }
    }
    
    func updateTask(){
        
        
    }
    
    func deleteTask(){
        
        
    }
    
    func removeListener(){
        
        
    }
}
