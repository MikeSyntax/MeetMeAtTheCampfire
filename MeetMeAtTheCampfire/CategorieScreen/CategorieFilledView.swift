//
//  CategorieFilledView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 04.03.24.
//

import SwiftUI

struct CategorieFilledView: View {
    
    @ObservedObject var categorieVm: CategorieViewModel
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.white).opacity(0.7)
            .frame(width: 100, height: 100)
            .padding(4)
            .overlay(
                VStack{
                    Text(categorieVm.categorie)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                    Text(String(categorieVm.tasksInCategorie))
                } 
//                    .badge(categorieVm.tasksInCategorie)
//                    .tag(4)
            )
            .background(.gray)
    }
}

#Preview {
    let categorie = CategorieModel(userId: "1", categorieName: "Preview", isDone: false, tasksInCategorie: 6)
    
    return CategorieFilledView(categorieVm: CategorieViewModel(categorieDesign: categorie))
}
