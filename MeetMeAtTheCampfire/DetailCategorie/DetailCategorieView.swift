//
//  DetailCategorieView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 05.03.24.
//

import SwiftUI

struct DetailCategorieView: View {
    let categorieVm: CategorieViewModel
       
       var body: some View {
           VStack {
               Text("Kategorie: \(categorieVm.categorie)")
               Text("Anzahl der Aufgaben: \(categorieVm.tasksInCategorie)")
               Spacer()
           }
           .background(
               Image("background")
                   .resizable()
                   .scaledToFill()
                   .opacity(0.2)
                   .ignoresSafeArea())
           
           .navigationBarTitle("Kategorie Details", displayMode: .inline)
       }
   }
//#Preview {
//    DetailCategorieView(categorie: CategorieModel(from: CategorieModel))
//}
