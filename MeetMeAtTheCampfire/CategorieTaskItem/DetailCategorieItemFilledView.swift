//
//  DetailCategorieItemFilledView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 13.03.24.
//


import SwiftUI

struct DetailCategorieItemFilledView: View {
    @ObservedObject var detailCategorieItemVm: DetailCategorieItemViewModel
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
        RoundedRectangle(cornerRadius: 6)
            .fill(colors.opacity(0.7))
            .frame(minHeight: 40)
            .padding(4)
            .overlay(
                HStack{
                    Text(detailCategorieItemVm.taskName)
                        .font(.system(size: 15))
                        .strikethrough(detailCategorieItemVm.taskIsDone, color: .primary)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    if detailCategorieItemVm.taskIsDone {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 21))
                            .foregroundColor(.primary)
                    } else {
                        Image(systemName: "circle")
                            .font(.system(size: 21))
                            .foregroundColor(.primary)
                    }
                }
                    .padding(
                        EdgeInsets(
                            top: 0,
                            leading: 10,
                            bottom: 0,
                            trailing: 10))
            )
            .frame(
                maxWidth: .infinity,
                maxHeight: 200)
            .padding(
                EdgeInsets(
                    top: -5,
                    leading: 20,
                    bottom: -5,
                    trailing: 20))
            .shadow(radius: 10)
            .onAppear{
                sortedColors()
            }
    }
    func sortedColors(){
        colors = bgColor.randomElement() ?? colors
    }
}


#Preview {
    DetailCategorieItemFilledView(detailCategorieItemVm: DetailCategorieItemViewModel(detailCategorieItemModel: TaskModel(categorieId: "1", taskName: "Camper packen", taskIsDone: false)))
}
