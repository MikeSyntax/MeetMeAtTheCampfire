//
//  HomeScreenView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 04.03.24.
//

import SwiftUI

struct HomeScreenView: View {
    @StateObject private var homeVm = HomeScreenViewModel()
    @StateObject private var detailCategorieVm = DetailCategorieViewModel()
    @StateObject private var detailCategorieItemVm = DetailCategorieItemViewModel(detailCategorieItemModel: TaskModel(categorieId: "1", taskName: "1", taskIsDone: false))
    
    @State private var showNewCategorieAlert: Bool = false
    @State private var newCategorie: String = ""
    @State private var tasksInCategorie: Int = 0
    @State private var showSettingsSheet: Bool = false
    @State private var showAnimation: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Divider()
                VStack{
                    ScrollView {
                        // Hier wird ein LazyVGrid (Lazy deshalb, da nur sichtbare Ansichten erstellt werden, um Speicher zu sparen), das eine Gitteransicht mit variabler Breite für die Spalten und einem Abstand zwischen den Elementen erstellt.
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 3), spacing: 20) {
                            ForEach(homeVm.categorieViewModels) { categorieViewModel in
                                NavigationLink(destination: DetailCategorieView(categorieVm: categorieViewModel, homeVm: homeVm, detailCategorieVm: detailCategorieVm, detailCategorieItemVm: detailCategorieItemVm)) {
                                    CategorieFilledView(categorieVm: categorieViewModel, detailCategorieVm: detailCategorieVm)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.vertical, 20)
                }
                VStack{
                    if homeVm.categorieViewModels.isEmpty {
                        HStack(alignment: .bottom){
                            VideoStartCategoriesView()
                                .opacity(0.5)
                        }
                        .frame(width: 300)
                        .cornerRadius(30)
                    }
                    if !homeVm.categorieViewModels.isEmpty && homeVm.categorieViewModels[0].tasksInCategorie == 0  {
                        HStack(){
                            VideoStartToDosView()
                                .opacity(0.5)
                        }
                        .frame(width: 300)
                        .cornerRadius(30)
                        .offset(x: 0, y: -100)
                    }
                }
                Divider()
                Button(action: {
                    showNewCategorieAlert.toggle()
                }, label: {
                    CategorieAddView()
                })
                .transition(.move(edge: .top))
                .animation(.default, value: showAnimation)
                .padding(.bottom)
            }
            .toolbar{
                Button {
                    showSettingsSheet.toggle()
                } label: {
                    Text("Settings")
                    Image(systemName: "gearshape")
                }
            }
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
                    .ignoresSafeArea())
            .navigationBarTitle("Meine Kategorien")
        }
        .alert("Neue Kategorie", isPresented: $showNewCategorieAlert) {
            TextField("Name", text: $newCategorie)
                .lineLimit(1)
            Button("zurück") {
                dismiss()
            }
            Button("Speichern") {
                homeVm.createCategorie(categorieName: newCategorie)
                newCategorie = ""
            }
        }
        .sheet(isPresented: $showSettingsSheet) {
            SettingsScreenView()
        }
        .onAppear {
            homeVm.readCategories()
            showAnimation = true
        }
        .onDisappear{
            homeVm.removeListener()
        }
    }
}


#Preview {
    HomeScreenView()
}
