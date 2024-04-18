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
    @Published var checkForTaskForShowVideo: Int = 0
    private var listener: ListenerRegistration? = nil
    
    init() {
        //tasksInCategorieCounter = detailCategorieItemViewModels.count
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
            
            tasksInCategorieCounter = detailCategorieItemViewModels.count
            
            tasksInCategorieCounter += 1
            let updatedCategorie = [
                "tasksInCategorie" : tasksInCategorieCounter
            ]
            
            FirebaseManager.shared.firestore.collection("categories").document(categorieId).updateData(updatedCategorie) {
                error in
                if let error {
                    print("update categorie failed: \(error)")
                } else {
                    print("update categorie done")
                }
            }
            
        } catch {
            print("Error creating new task: \(error)")
        }
    }
    
    @MainActor
    func readTasks(categorieId: String?){
        guard let categorieId = categorieId else {
            return
        }
        
        self.listener = FirebaseManager.shared.firestore.collection("tasksInCategorie").whereField("categorieId", isEqualTo: categorieId).addSnapshotListener{ querySnapshot, error in
            //Error hinzugefügt
            if let error = error {
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
            self.detailCategorieItemViewModels = detailCategorieItemViewModels
            
            if let checkForTaskForShowVideo = self.detailCategorieItemViewModels.first?.taskName.count {
                self.checkForTaskForShowVideo = checkForTaskForShowVideo
            }
            
        }
    }
    
    
    func updateTask(detailCategorieItemVm: DetailCategorieItemViewModel, taskId: String?){
        guard let taskId = taskId else {
            return
        }
        
        let updatedTask = [
            "taskIsDone" : detailCategorieItemVm.taskIsDone ? false : true
        ]
        
        FirebaseManager.shared.firestore.collection("tasksInCategorie").document(taskId).setData(updatedTask, merge: true) {
            error in
            if let error {
                print("update task failed: \(error)")
            } else {
                print("update task done")
                
            }
        }
    }
    
    func deleteTask(categorieId: String?) {
        guard let categorieId = categorieId else {
            return
        }
        
        let ref = FirebaseManager.shared.firestore.collection("tasksInCategorie")
        //Kategorie überprüfen
        ref.whereField("categorieId", isEqualTo: categorieId)
        //isDone auf true überprüfen
            .whereField("taskIsDone", isEqualTo: true)
            .getDocuments() { snapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                    return
                }
                //alle bei denen die Bedingungen passen löschen
                for document in snapshot!.documents {
                    ref.document(document.documentID).delete() { error in
                        if let error = error {
                            print("Error deleting document: \(error)")
                        } else {
                            print("Document successfully deleted")
                            
                            self.tasksInCategorieCounter = self.detailCategorieItemViewModels.count + 1
                            
                            self.tasksInCategorieCounter -= 1
                            let updatedCategorie = [
                                "tasksInCategorie" : self.tasksInCategorieCounter
                            ]
                            
                            FirebaseManager.shared.firestore.collection("categories").document(categorieId).updateData(updatedCategorie) {
                                error in
                                if let error {
                                    print("update categorie failed: \(error)")
                                } else {
                                    print("update categorie done")
                                }
                            }
                        }
                    }
                }
        }
    }

    func removeListener() {
        self.listener = nil
        self.detailCategorieItemViewModels = []
        
    }
}
