//
//  CalendarInfoButtonView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 23.04.24.
//

import SwiftUI

struct CalendarInfoButtonView: View {
    
    var body: some View {
        if SettingsScreenView().isDark {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white).opacity(0.8)
                .frame(width: 100, height: 100)
                .padding(4)
                .overlay(
                    VStack{
                        Text("Info")
                            .padding(2)
                            .foregroundColor(.gray)
                            .bold()
                        Image(systemName: "info.square")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.gray)
                    }
                )
                .shadow(radius: 10)
        } else {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white).opacity(1.0)
                .frame(width: 100, height: 100)
                .padding(4)
                .overlay(
                    VStack{
                        Text("Info")
                            .padding(2)
                            .foregroundColor(.gray)
                            .bold()
                        Image(systemName: "info.square")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.gray)
                    }
                )
                .shadow(radius: 10)
        }
    }
}

#Preview {
    CalendarInfoButtonView()
}
