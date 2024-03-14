//
//  DetailCategorieView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 05.03.24.
//

import SwiftUI

struct DetailCategorieView: View {
    
    let categorieVm: CategorieViewModel
    
    @ObservedObject var homeVm: HomeScreenViewModel
    @ObservedObject var detailCategorieVm: DetailCategorieViewModel
    
    @State private var showNewTaskAlert: Bool = false
    @State private var newTask: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text(categorieVm.categorie)
                .font(.title)
            Text("Anzahl der Aufgaben: \(detailCategorieVm.detailCategorieItemViewModels.count)")
                .font(.callout)
                .bold()
                VStack {
                    ForEach(detailCategorieVm.detailCategorieItemViewModels, id: \.taskName) { detailCategorieViewModel in
                        DetailCategorieItemFilledView(detailCategorieItemVm: detailCategorieViewModel)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    detailCategorieVm.deleteTask()
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                            .onTapGesture {
                                detailCategorieVm.updateTask()
                            }
                }
            }
            Spacer()
            Button(action: {
                showNewTaskAlert.toggle()
            }, label: {
                DetailCategorieItemAddView()
            })
            
            ButtonTextAction(iconName: "trash", text: "Kategorie löschen"){
                homeVm.deleteCategorie(categorieVm: categorieVm)
                dismiss()
            }
            .padding()
        }
        .scrollContentBackground(.hidden)
        .background(
            Image("background")
                .resizable()
                .scaledToFill()
                .opacity(0.2)
                .ignoresSafeArea())
        
        .navigationBarTitle("Kategorie ToDo´s", displayMode: .inline)
        .alert("Neuen Task erstellen", isPresented: $showNewTaskAlert) {
            TextField("Beschreibung", text: $newTask)
                .lineLimit(1)
            Button("zurück") {
                showNewTaskAlert.toggle()
            }
            Button("Speichern") {
                detailCategorieVm.createNewTask(taskName: newTask, categorieId: categorieVm.categorieViewModel.id)
                newTask = ""
            }
        }
        .onAppear{
            detailCategorieVm.readTasks(categorieId: categorieVm.categorieViewModel.id)
        }
    }
}
