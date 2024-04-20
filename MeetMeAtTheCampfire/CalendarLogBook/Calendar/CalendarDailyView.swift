//
//  CalendarDailyView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 18.03.24.
//

import SwiftUI

struct CalendarDailyView: View {
    var date: Date
    let weekendColor = Color(cgColor: CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1))
    
    var body: some View {
        Text("\(date.get(.day))")
            .foregroundStyle(date.isWeekend() ? weekendColor : .primary)
            .background{
                if date.isToday(){
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.red)
                }
            }
    }
}
