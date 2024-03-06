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
                ScrollView(.horizontal) { // Horizontale Scroll-Ansicht
                    HStack(spacing: 20) { // HStack für horizontales Layout
                        ForEach(homeVm.categorieViewModels) { categorieViewModel in
                            NavigationLink(destination: DetailCategorieView(categorieVm: categorieViewModel)) {
                                CategorieFilledView(categorieVm: categorieViewModel)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    homeVm.deleteCategorie(categorieVm: categorieViewModel)
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .frame(height: 200) // Höhe der horizontalen Liste
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
            .navigationBarTitle("Home") // Optional: Setzt den Titel der Navigationsleiste
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
                //Alle Variablen wieder leeren
                newCategorie = ""
            }
        }
        .sheet(isPresented: $showSettingsSheet) {
            SettingsScreenView()
        }
        .onAppear {
            homeVm.readCategories()
        }
    }
}

#Preview {
    HomeScreenView()
}
