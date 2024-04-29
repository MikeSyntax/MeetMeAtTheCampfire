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
    @ObservedObject var detailCategorieItemVm: DetailCategorieItemViewModel
    @State private var showNewTaskAlert: Bool = false
    @State private var newTask: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text(categorieVm.categorie)
                .font(.title)
            Text("Anzahl der Aufgaben: \(detailCategorieVm.detailCategorieItemViewModels.count)")
                .font(.system(size: 10))
                .bold()
            Button(action: {
                showNewTaskAlert.toggle()
            }, label: {
                DetailCategorieItemAddView()
            })
            ScrollView{
                LazyVStack {
                    ForEach(detailCategorieVm.detailCategorieItemViewModels, id: \.taskName) { detailCategorieViewModel in
                        DetailCategorieItemFilledView(detailCategorieItemVm: detailCategorieViewModel)
                            .onTapGesture {
                                detailCategorieVm.updateTask(detailCategorieItemVm: detailCategorieItemVm, taskId: detailCategorieViewModel.detailCategorieItemModel.id)
                            }
                    }
                }
                //Löschen der aller Tasks in dieser Kategorie
                Button(role: .destructive) {
                    detailCategorieVm.deleteTask(categorieId: categorieVm.categorieViewModel.id)
                } label: {
                    Text("Erledigte ToDo´s löschen")
                    Image(systemName: "trash")
                }
                .buttonStyle(.borderedProminent)
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
            }
            Spacer()
            
            //Beim Löschen der Kategorie werden auch alle Tasks gelöscht!!
            ButtonTextAction(iconName: "trash", text: "Gesamte Kategorie löschen"){
                homeVm.deleteCategorie(categorieVm: categorieVm)
                detailCategorieVm.deleteAllTask(categorieId: categorieVm.categorieViewModel.id)
                dismiss()
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            Divider()
        }
        .scrollContentBackground(.hidden)
        .background(
            Image("background")
                .resizable()
                .scaledToFill()
                .opacity(0.2)
                .ignoresSafeArea(.all))
        
        .navigationBarTitle("Kategorie ToDo´s", displayMode: .inline)
        .navigationBarBackButtonHidden()
        .toolbar{ ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading){
            Button("Zurück") {
                dismiss()}}
        }
        .alert("Neues ToDo erstellen", isPresented: $showNewTaskAlert) {
            TextField("Beschreibung", text: $newTask)
                .lineLimit(1)
                .autocorrectionDisabled()
            Button("Zurück") {
                newTask = ""
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
        .onDisappear{
            detailCategorieVm.removeListener()
        }
    }
}


