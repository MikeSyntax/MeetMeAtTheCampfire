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
            .padding(4)
            .overlay(
                HStack{
                    Text("Neues ToDo")
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
            .frame(maxWidth: .infinity, maxHeight: 40)
            .background(.white)
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            .shadow(radius: 10)
    }
}
#Preview {
    DetailCategorieItemAddView()
}
