//
//  CalendarDailyView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 18.03.24.
//

import SwiftUI

//struct CalendarDailyView: View {
//    var date: Date
//    let weekendColor = Color(cgColor: CGColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1))
//    
//    var body: some View {
//        //aktuellen Tag anzeigen
//        Text("\(date.get(.day))")
//        //Wochenende werden die Daten grau angezeigt
//            .foregroundStyle(date.isWeekend() ? weekendColor : .primary)
//            .background {
//                if date.isToday() {
//                    Circle()
//                        .frame(width: 30,height: 30)
//                        .foregroundStyle(.red)
//                }
//            }
//    }
//}
//
//#Preview("Heute") {
//    CalendarDailyView(date: Date())
//}
//
//#Preview("Wochenende") {
//    CalendarDailyView(date: Date(timeIntervalSince1970: TimeInterval(1711900977)))
//}



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
                        .frame(width: 30,height: 30)
                        .foregroundStyle(.red)
                }
            }
    }
}

#Preview("Heute") {
    CalendarDailyView(dateVm: CalendarViewModel(date: Date()))
}

#Preview("Wochenende") {
    CalendarDailyView(dateVm: CalendarViewModel(date: Date(timeIntervalSince1970: TimeInterval(1711900977))))
}
