//
//  DetailCategorieView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 05.03.24.
//

import SwiftUI

struct DetailCategorieView: View {
    let categorie: CategorieModel
       
       var body: some View {
           VStack {
               Text("Kategorie: \(categorie.categorieName)")
               Text("Anzahl der Aufgaben: \(categorie.tasksInCategorie)")
               Spacer()
           }
           .padding()
           .navigationBarTitle("Kategorie Details", displayMode: .inline)
       }
   }
//#Preview {
//    DetailCategorieView(categorie: CategorieModel(from: categorie))
//}
