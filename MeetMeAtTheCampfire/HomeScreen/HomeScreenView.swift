//
//  HomeScreenView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 04.03.24.
//

import SwiftUI

struct HomeScreenView: View {
    @StateObject private var homeVm = HomeScreenViewModel()
    @State private var showNewCategorieAlert: Bool = false
    @State private var newCategorie: String = ""
    @State private var tasksInCategorie: String = ""
    @State private var showSettingsSheet: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                ScrollView {
                    // Hier wird ein LazyVGrid (Lazy deshalb, da nur sichtbare Ansichten erstellt werden, um Speicher zu sparen), das eine Gitteransicht mit variabler Breite für die Spalten und einem Abstand zwischen den Elementen erstellt.
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 3), spacing: 20) {
                        ForEach(homeVm.categorieViewModels) { categorieViewModel in
                            NavigationLink(destination: DetailCategorieView(categorieVm: categorieViewModel, homeVm: homeVm)) {
                                CategorieFilledView(categorieVm: categorieViewModel)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical, 20)
                
                Button(action: {
                    showNewCategorieAlert.toggle()
                }, label: {
                    CategorieAddView()
                })
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
            TextField("Anzahl Tasks", text: $tasksInCategorie)
                .lineLimit(1)
            Button("zurück") {
                dismiss()
            }
            Button("Speichern") {
                homeVm.createCategorie(categorieName: newCategorie, tasksInCategorie: Int(tasksInCategorie) ?? 4)
                newCategorie = ""
                tasksInCategorie = ""
            }
        }
        .sheet(isPresented: $showSettingsSheet) {
            SettingsScreenView()
        }
        .onAppear {
            homeVm.readCategories()
        }
        .onDisappear{
            homeVm.removeListener()
        }
    }
}


#Preview {
    HomeScreenView()
}
