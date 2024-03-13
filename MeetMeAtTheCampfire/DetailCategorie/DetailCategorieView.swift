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
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        var tasksCounter = detailCategorieVm.detailCategorieItemViewModels.count
        
        VStack {
            Text(categorieVm.categorie)
                .font(.title)
            Text("Anzahl der Aufgaben: \(tasksCounter)")
                .font(.callout)
                .bold()
            
            Spacer()
            
            ForEach(detailCategorieVm.detailCategorieItemViewModels, id: \.taskName){
                detailCategorieViewModel in
                DetailCategorieItemFilledView(detailCategorieItemVm: detailCategorieViewModel)
            }
            
            Spacer()
            
            Button {
                homeVm.deleteCategorie(categorieVm: categorieVm)
                dismiss()
            } label: {
                Text("Kategorie löschen")
                Image(systemName: "trash")
            }
        }
        .background(
            Image("background")
                .resizable()
                .scaledToFill()
                .opacity(0.2)
                .ignoresSafeArea())
        
        .navigationBarTitle("Kategorie ToDo´s", displayMode: .inline)
    }
}




//#Preview {
//    DetailCategorieView(categorie: CategorieModel(from: CategorieModel))
//}
