//
//  CalendarMonthlyView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 18.03.24.
//

import SwiftUI

struct CalendarMonthlyView: View {
    
    @ObservedObject var calendarDetailItemVm: CalendarDetailItemViewModel
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    var month: Date
    
    var body: some View {
        VStack{
            Text(CalendarUtils.getMonthCaption(month))
                .font(.title2)
                .padding(.leading, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: columns, spacing: 25) {
                ForEach(0..<month.getWeekday(), id: \.self) { _ in
                    Spacer()
                }
                
                ForEach(month.getAllDaysToNextMonth(), id: \.self){ day in
                    NavigationLink(destination: CalendarDetailItemView(calendarDetailItemVm: CalendarDetailItemViewModel(calendarItemModel: LogBookModel(userId: calendarDetailItemVm.userId, formattedDate: calendarDetailItemVm.formattedDate, logBookText: calendarDetailItemVm.logBookText, latitude: calendarDetailItemVm.latitude, longitude: calendarDetailItemVm.longitude, imageUrl: calendarDetailItemVm.imageUrl, containsLogBookEntry: calendarDetailItemVm.containsLogBookEntry), date: day))) {
                        CalendarDailyView(date: day)
                    }
                }
            }
        }
    }
}

