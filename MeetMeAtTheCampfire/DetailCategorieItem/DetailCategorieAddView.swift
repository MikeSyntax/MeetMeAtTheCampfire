//
//  DetailCategorieItemAddView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 13.03.24.
//

import SwiftUI

struct DetailCategorieItemAddView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.white).opacity(0.7)
            .frame(width: .infinity, height: 40)
            .padding(4)
            .overlay(
                HStack{
                    Text("Add ToDo")
                        .lineLimit(2)
                        .foregroundColor(.gray)
                        .bold()
                    Spacer()
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(.gray)
                    
                }
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            )
            .background(.green)
            .padding(5)
            .shadow(radius: 10)
            
    }
}
#Preview {
    DetailCategorieItemAddView()
}
