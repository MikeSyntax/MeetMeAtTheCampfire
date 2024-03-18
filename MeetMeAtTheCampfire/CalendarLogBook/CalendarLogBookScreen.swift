//
//  CalendarLogBookScreen.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 18.03.24.
//

import SwiftUI

struct CalendarLogBookScreen: View {
    
    var date: Date
    
    
    var body: some View {
        //aktuellen Tag anzeigen
        Text("\(date.get(.day))")
        //Wochenende werden die Daten grau angezeigt
            .foregroundStyle(date.isWeekend() ? weekendColor : .primary)
            .background {
                if date.isToday() {
                    Circle()
                        .frame(width: 30,height: 30)
                        .foregroundStyle(.red)
                }
            }
    }
}

#Preview("Heute") {
    CalendarLogBookScreen(date: Date())
}

#Preview("Wochenende") {
    CalendarLogBookScreen(date: Date(timeIntervalSince1970: TimeInterval(1711900977)))
}
