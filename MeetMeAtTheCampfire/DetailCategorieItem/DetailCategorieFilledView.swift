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
                        if detailCategorieItemVm.taskIsDone {
                            Text(detailCategorieItemVm.taskName)
                                .strikethrough()
                                .foregroundColor(.black)
                                .bold()
                        } else {
                            Text(detailCategorieItemVm.taskName)
                                .foregroundColor(.black)
                                .bold()
                        }
                        Spacer()
                        Image(systemName: detailCategorieItemVm.taskIsDone ?     "checkmark.circle.fill" : "circle")
                            .font(.title)
                            .bold()
                            .foregroundColor(color)
                            
                    }
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                )
                .frame(maxWidth: .infinity, maxHeight: 40)
                .lineLimit(1)
                .background(color)
                .padding(5)
                .shadow(radius: 10)
        }
    }
#Preview {
    DetailCategorieItemFilledView(detailCategorieItemVm: DetailCategorieItemViewModel(detailCategorieItemModel: TaskModel(userId: "1", taskName: "Camper packen", taskIsDone: false)))
}
