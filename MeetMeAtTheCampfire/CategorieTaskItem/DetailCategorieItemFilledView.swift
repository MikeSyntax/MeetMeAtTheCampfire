//
//  DetailCategorieItemFilledView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 13.03.24.
//

import SwiftUI

struct DetailCategorieItemFilledView: View {
    @ObservedObject var detailCategorieItemVm: DetailCategorieItemViewModel
    @State private var bgColor: [Color] = [.blue, .green, .yellow, .red, .pink, .brown, .orange, .purple, .cyan, .gray, .mint, .indigo]
    
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.white).opacity(0.7)
            .padding(4)
            .overlay(
                HStack{
                    Text(detailCategorieItemVm.taskName)
                        .strikethrough(detailCategorieItemVm.taskIsDone, color: .black)
                        .foregroundColor(.black)
                        .bold()
                    
                    Spacer()
                    
                    if detailCategorieItemVm.taskIsDone {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                    } else {
                        Image(systemName: "circle")
                    }
                }
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            )
            .lineLimit(1)
            .background(bgColor.randomElement())
            .shadow(radius: 10)
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
    }
}
#Preview {
    DetailCategorieItemFilledView(detailCategorieItemVm: DetailCategorieItemViewModel(detailCategorieItemModel: TaskModel(categorieId: "1", taskName: "Camper packen", taskIsDone: false)))
}
