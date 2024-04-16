//
//  CalendarDailyView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 18.03.24.
//

import SwiftUI

struct CalendarDailyView: View {
    @ObservedObject var dateVm: CalendarViewModel
    @ObservedObject var calendarDetailItemVm: CalendarDetailItemViewModel
    
    var hasLogBookText: Bool {
        calendarDetailItemVm.newEntryLogs.contains(where: { $0.logBookText != "" && !$0.logBookText.isEmpty && $0.formattedDate == calendarDetailItemVm.formattedDate })
        }
    
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
                } else if hasLogBookText {
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.blue)
                    
                }
            }
    }
}

#Preview("Heute") {
    CalendarDailyView(dateVm: CalendarViewModel(date: Date()), calendarDetailItemVm: CalendarDetailItemViewModel(calendarItemModel: LogBookModel(userId: "1", formattedDate: "", logBookText: "", latitude: 0.0, longitude: 0.0, imageUrl: "", containsLogBookEntry: false), dateVm: CalendarViewModel(date: Date())))
}

#Preview("Wochenende") {
    CalendarDailyView(dateVm: CalendarViewModel(date: Date(timeIntervalSince1970: TimeInterval(1711900977))), calendarDetailItemVm: CalendarDetailItemViewModel(calendarItemModel: LogBookModel(userId: "1", formattedDate: "", logBookText: "", latitude: 0.0, longitude: 0.0, imageUrl: "", containsLogBookEntry: false), dateVm: CalendarViewModel(date: Date())))
}

#Preview("Log is true") {
    CalendarDailyView(dateVm: CalendarViewModel(date: Date(timeIntervalSince1970: TimeInterval(1713117721))), calendarDetailItemVm: CalendarDetailItemViewModel(calendarItemModel: LogBookModel(userId: "1", formattedDate: "14.04.2024", logBookText: "12", latitude: 0.0, longitude: 0.0, imageUrl: "", containsLogBookEntry: true), dateVm: CalendarViewModel(date: Date())))
}

