//
//  CalendarMonthlyView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 18.03.24.
//

import Foundation
import SwiftUI

//let columns = Array(repeating: GridItem(.flexible()), count: 7)
//struct CalendarMonthlyView: View {
//    var month: Date
//    var body: some View {
//        VStack {
//            Text(CalendarUtils.getMonthCaption(month))
//                .font(.title2)
//                .padding(.leading, 9)
//                .frame(maxWidth: .infinity, alignment: .leading)
//            LazyVGrid(columns: columns, spacing: 25) {
//                ForEach(0..<month.getWeekday(), id: \.self){ _ in
//                    Spacer()
//                }
//                ForEach(month.getAllDaysToNextMonth(), id: \.self){ day in
//                    NavigationLink(destination: Text("Todo View erstellen und mit TextField und Firebase verbinden")){
//                        CalendarDailyView(date: day)
//                       // Text(CalendarUtils.getDayCaption(day))
//                    }
//                }
//            }
//        }
//    }
//}
//#Preview {
//    CalendarMonthlyView(month: Date())
//}

struct CalendarMonthlyView: View {
    @ObservedObject var dateVm : CalendarViewModel
    
    var body: some View {
        VStack {
            Text(CalendarUtils.getMonthCaption(dateVm.date))
                .font(.title2)
                .padding(.leading, 9)
                .frame(maxWidth: .infinity, alignment: .leading)
            LazyVGrid(columns: dateVm.columns, spacing: 25) {
                ForEach(0..<dateVm.getWeekday(date: dateVm.date), id: \.self){ _ in
                    Spacer()
                }
                ForEach(dateVm.getAllDaysToNextMonth(from: dateVm.date), id: \.self){ day in
                    NavigationLink(destination: Text("Hier eigene View")){
                        CalendarDailyView(dateVm: CalendarViewModel(date: day))
                    }
                }
            }
        }
    }
}

#Preview {
    CalendarMonthlyView(dateVm: CalendarViewModel(date: Date()))
}
