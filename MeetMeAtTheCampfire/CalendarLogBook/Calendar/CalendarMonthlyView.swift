//
//  CalendarMonthlyView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 18.03.24.
//

import SwiftUI

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
                    NavigationLink(destination: CalendarDetailItemView(calendarDetailItemVm: CalendarDetailItemViewModel(calendarItemModel: LogBookModel(userId: "1", formattedDate: "1", logBookText: "", laditude: 52.0, longitude: 8.25), calendarVm: CalendarViewModel(date: day)))){
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
