//
//  DetailCategorieItemFilledView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 13.03.24.
//

import SwiftUI

struct DetailCategorieItemFilledView: View {
    @ObservedObject var detailCategorieItemVm: DetailCategorieItemViewModel
    @State private var bgColor: [Color] = [.blue, .green, .yellow, .red, .pink, .brown]
    
    
    var body: some View {
        
        let color = bgColor.randomElement()
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
                    Image(systemName: detailCategorieItemVm.taskIsDone ?     "checkmark.circle" : "circle")
                        .font(.title)
                        .foregroundColor(color)
                    
                }
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            )
            .lineLimit(1)
            .background(color)
            .shadow(radius: 10)
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
    }
}
#Preview {
    DetailCategorieItemFilledView(detailCategorieItemVm: DetailCategorieItemViewModel(detailCategorieItemModel: TaskModel(categorieId: "1", taskName: "Camper packen", taskIsDone: false)))
}
