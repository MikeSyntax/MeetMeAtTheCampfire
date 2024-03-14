//
//  CategorieFilledView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 04.03.24.
//

import SwiftUI

struct CategorieFilledView: View {
    
    @ObservedObject var categorieVm: CategorieViewModel
    @ObservedObject var detailCategorieVm: DetailCategorieViewModel
    @State private var bgColor: [Color] = [.blue, .green, .yellow, .red, .pink, .brown]
    
    var body: some View {
        
        let color = bgColor.randomElement()
        RoundedRectangle(cornerRadius: 10)
            .fill(color ?? .white).opacity(0.7)
            .frame(width: 100, height: 100)
            .overlay(
                VStack{
                    Text(categorieVm.categorie)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(EdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 2))
                    Spacer() // Fügt den verbleibenden Platz ein
                    Divider()
                    Text(String(categorieVm.tasksInCategorie))
                        .padding(8)
                        .background(.red)
                        .foregroundColor(.black)
                        .clipShape(Circle())
                }
                    .padding(EdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 0))
            )
            .shadow(radius: 10)
    }
}


#Preview {
    let categorie = CategorieModel(userId: "1", categorieName: "Preview", isDone: false, tasksInCategorie: 6)
    
    return CategorieFilledView(categorieVm: CategorieViewModel(categorieDesign: categorie), detailCategorieVm: DetailCategorieViewModel())
}
