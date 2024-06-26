//
//  CalendarInfoButtonView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 23.04.24.
//

import SwiftUI

struct CalendarInfoButtonView: View {
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.white).opacity(0.8)
            .frame(
                width: 65,
                height: 65)
            .padding(4)
            .overlay(
                VStack{
                    Text("Info")
                        .padding(2)
                        .foregroundColor(.gray)
                        .bold()
                    Image(systemName: "info.square")
                        .font(.title)
                        .bold()
                        .foregroundColor(.gray)
                }
            )
            .shadow(radius: 10)
    }
}

#Preview {
    CalendarInfoButtonView()
}
