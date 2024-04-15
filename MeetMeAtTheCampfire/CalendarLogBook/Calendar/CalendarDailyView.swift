//
//  CalendarDailyView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 18.03.24.
//

import SwiftUI

struct CalendarDailyView: View {
    @ObservedObject var dateVm: CalendarViewModel
    //@ObservedObject var calendarDetailItemVm: CalendarDetailItemViewModel
    
    
    var body: some View {
        //aktuellen Tag anzeigen
        Text("\(dateVm.get(.day))")
        //Wochenende werden die Daten grau angezeigt
            .foregroundStyle(dateVm.isWeekend(date: dateVm.date) ? dateVm.weekendColor : .primary)
            .background {
                if dateVm.isToday(date: dateVm.date) {
                    Circle()
                        .frame(width: 30,height: 30)
                        .foregroundStyle(.red)
                }
//                else if calendarDetailItemVm.newEntryLogs.contains (where: {$0.containsLogBookEntry && $0.formattedDate == calendarDetailItemVm.formattedDate }) {
//                    Circle()
//                        .frame(width: 30,height: 30)
//                        .foregroundStyle(.blue)
//                }
            }
//            .overlay(alignment: .bottomTrailing) {
//                if calendarDetailItemVm.contains.LogBookEntry {
//                    Image(systemName: "circle.fill")
//                        .font(.subheadline)
//                        .padding(-9)
//                        .foregroundStyle(.blue)
//                }
//            }
    }
}

//#Preview("Heute") {
//    CalendarDailyView(dateVm: CalendarViewModel(date: Date()))
//}
//
//#Preview("Wochenende") {
//    CalendarDailyView(dateVm: CalendarViewModel(date: Date(timeIntervalSince1970: TimeInterval(1711900977))))
//}
//
//#Preview("Log is true") {
//    CalendarDailyView(dateVm: CalendarViewModel(date: Date(timeIntervalSince1970: TimeInterval(1711900977))))
//}

