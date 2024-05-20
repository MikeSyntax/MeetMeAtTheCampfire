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
    @State private var showDeleteAlert: Bool = false
    @State private var showEditTaskAlert: Bool = false
    @State private var detailEditCategorieViewModel: DetailCategorieItemViewModel? = nil
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
                            .onLongPressGesture {
                                detailEditCategorieViewModel = detailCategorieViewModel
                                showEditTaskAlert.toggle()
                            }
                    }
                    .alert("ToDo bearbeiten", isPresented: $showEditTaskAlert, actions: {
                        TextField("Beschreibung", text: $newTask)
                            .lineLimit(1)
                            .autocorrectionDisabled()
                        Button("Speichern") {
                            detailCategorieVm.updateTask(
                                taskName: newTask,
                                taskId: detailEditCategorieViewModel?.detailCategorieItemModel.id
                            )
                        }
                        Button("Abbrechen", role: .cancel) {
                            // Optionale Abbrechen-Logik
                        }
                    }, message: {
                        Text("Neuen Text eingeben")
                    })
                    .onChange(of: showEditTaskAlert) {_, isPresented in
                        if isPresented {
                            newTask = detailEditCategorieViewModel?.taskName ?? "no task found"
                        }
                    }
                }
                ButtonDestructiveTextAction(
                    iconName: "trash",
                    text: "Erledigte ToDo´s löschen") {
                        detailCategorieVm.deleteTask(categorieId: categorieVm.categorieViewModel.id)
                    }
                    .padding(
                        EdgeInsets(
                            top: 5,
                            leading: 0,
                            bottom: 5,
                            trailing: 0))
            }
            Divider()
            ButtonTextAction(
                iconName: "trash",
                text: "Gesamte Kategorie löschen"){
                    showDeleteAlert.toggle()
                }
                .actionSheet(isPresented: $showDeleteAlert) {
                    ActionSheet(
                        title: Text("Gesamte Kategorie löschen"),
                        message: Text("Alle Daten sind unwiederbringlich gelöscht"),
                        buttons: [
                            .destructive(Text("Erledigte ToDo´s löschen"), action: {
                                detailCategorieVm.deleteTask(categorieId: categorieVm.categorieViewModel.id)
                            }),
                            .destructive(Text("Gesamte Kategorie löschen"), action: {
                                homeVm.deleteCategorie(categorieVm: categorieVm)
                                detailCategorieVm.deleteAllTask(categorieId: categorieVm.categorieViewModel.id)
                                dismiss()
                            }),
                            .cancel(Text("Abbrechen"))
                        ]
                    )
                }
            Divider()
        }
        .scrollContentBackground(.hidden)
        .background(
            Image("background")
                .resizable()
                .scaledToFill()
                .opacity(0.2)
                .ignoresSafeArea(.all))
        
        .navigationBarTitle("ToDo´s in der Kategorie", displayMode: .inline)
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
        .background(Color(UIColor.systemBackground))
    }
}


