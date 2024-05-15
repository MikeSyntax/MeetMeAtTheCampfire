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
    @State private var bgColor: [Color] = [
        .blue,
        .green,
        .yellow,
        .red,
        .pink,
        .brown,
        .orange,
        .purple,
        .cyan,
        .gray,
        .mint,
        .indigo]
    
    @State private var colors: Color = .white
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(colors.opacity(0.7))
            .frame(
                width: 95,
                height: 95)
            .overlay(
                VStack{
                    Text(categorieVm.categorie)
                        .lineLimit(2)
                        .font(.system(size: 14))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(
                            EdgeInsets(
                                top: 0,
                                leading: 2,
                                bottom: 0,
                                trailing: 2))
                    Spacer()
                    Divider()
                    Text(String( categorieVm.tasksInCategorie ))
                        .font(.system(size: 14))
                        .padding(8)
                        .background(.red)
                        .foregroundColor(.black)
                        .clipShape(Circle())
                }
                    .padding(
                        EdgeInsets(
                            top: 4,
                            leading: 0,
                            bottom: 4,
                            trailing: 0))
            )
            .shadow(radius: 10)
            .onAppear{
                sortedColors()
            }
    }
    func sortedColors(){
        colors = bgColor.randomElement() ?? Color.white
    }
}


#Preview {
    let categorie = CategorieModel(userId: "1", categorieName: "Preview for enter and ", isDone: false, tasksInCategorie: 6)
    
    return CategorieFilledView(categorieVm: CategorieViewModel(categorieDesign: categorie), detailCategorieVm: DetailCategorieViewModel())
}
