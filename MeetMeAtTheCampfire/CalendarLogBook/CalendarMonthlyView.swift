//
//  CalendarMonthlyView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 18.03.24.
//

import Foundation
import SwiftUI

let columns = Array(repeating: GridItem(.flexible()), count: 7)

struct CalendarMonthlyView: View {
    
    var month: Date
    
    var body: some View {
        VStack {
            Text(CalendarUtils.getMonthCaption(month))
                .font(.title2)
                .padding(.leading, 9)
                .frame(maxWidth: .infinity, alignment: .leading)
            LazyVGrid(columns: columns, spacing: 25) {
                ForEach(0..<month.getWeekday(), id: \.self){ _ in
                    Spacer()
                }
                
                ForEach(month.getAllDaysToNextMonth(), id: \.self){ day in
                    NavigationLink(destination: Text("Hier eigene View")){
                        CalendarLogBookScreen(date: day)
                    }
                }
            }
        }
    }
}

#Preview {
    CalendarMonthlyView(month: Date())
}
