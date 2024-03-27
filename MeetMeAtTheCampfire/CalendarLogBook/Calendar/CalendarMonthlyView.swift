//
//  CalendarMonthlyView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 18.03.24.
//

import SwiftUI

struct CalendarMonthlyView: View {
    @ObservedObject var dateVm : CalendarViewModel
    @ObservedObject var calendarDetailItemVm: CalendarDetailItemViewModel
    
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
                ForEach(dateVm.getAllDaysToNextMonth(from: dateVm.date), id: \.self) { day in
                    NavigationLink(destination: CalendarDetailItemView(calendarDetailItemVm: CalendarDetailItemViewModel(calendarItemModel: LogBookModel(userId: "1", formattedDate: "1", logBookText: "", laditude: calendarDetailItemVm.latitude, longitude: calendarDetailItemVm.longitude), calendarVm: CalendarViewModel(date: day)))) {
                        CalendarDailyView(dateVm: CalendarViewModel(date: day))
                    }
                }
            }
        }
    }
}

