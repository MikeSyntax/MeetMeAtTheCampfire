//
//  CategorieAddView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 04.03.24.
//

import SwiftUI

struct CategorieAddView: View {
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.white).opacity(0.7)
            .frame(width: 100, height: 100)
            .padding(4)
            .overlay(
                VStack{
                    Text("Add new")
                        .padding(2)
                        .foregroundColor(.gray)
                        .bold()
                    Image(systemName: "plus")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.gray)
                }
            )
            .shadow(radius: 10)
    }
}

#Preview {
   CategorieAddView()
}