//
//  CalendarDailyView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 18.03.24.
//

import SwiftUI

struct CalendarDailyView: View {
    @ObservedObject var dateVm: CalendarViewModel
    var body: some View {
        //aktuellen Tag anzeigen
        Text("\(dateVm.get(.day))")
        //Wochenende werden die Daten grau angezeigt
            .foregroundStyle(dateVm.isWeekend(date: dateVm.date) ? dateVm.weekendColor : .primary)
            .background {
                if dateVm.isToday(date: dateVm.date) {
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.red)
                }
            }
    }
}
