//
//  HomeScreenView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 04.03.24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct HomeScreenView: View {
    
    @StateObject private var homeVm = HomeScreenViewModel()
    @EnvironmentObject var authVm: AuthViewModel
    
    @State private var showNewCategorieAlert = false
    @State private var newCategorie: String = ""
    @State private var tasksInCategorie: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(homeVm.categories) { categorie in
                    NavigationLink(destination: DetailCategorieView(categorie: categorie)) {
                        VStack {
                            HStack {
                                Text(categorie.categorieName)
                                Text("\(categorie.tasksInCategorie)")
                            }
                        }
                    }
                }
            }
            .toolbar{
                ButtonTextAction(iconName: "rectangle.portrait.and.arrow.right", text: ""){
                    authVm.logout()
                }
            }
        }
        .alert("Neue Kategorie", isPresented: $showNewCategorieAlert){
            TextField("Name", text: $newCategorie)
                .lineLimit(1)
            TextField("Anzahl", text: $tasksInCategorie)
                .lineLimit(1)
            Button("zurück"){
                dismiss()
            }
            Button("Speichern"){
                homeVm.createCategorie(categorieName: newCategorie, tasksInCategorie: Int(tasksInCategorie) ?? 0)
                //Alle Variablen wieder leeren
                newCategorie = ""
            }
        }
        Button(action: {
            showNewCategorieAlert.toggle()
        }, label: {
            CategorieAddView()
        })
        .padding()
        .onAppear{
            homeVm.readCategories()
        }
    }
        
}

#Preview {
HomeScreenView()
}
