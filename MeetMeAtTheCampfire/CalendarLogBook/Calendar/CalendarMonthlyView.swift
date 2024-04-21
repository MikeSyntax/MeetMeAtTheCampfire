//
//  CalendarMonthlyView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 18.03.24.
//

import SwiftUI

struct CalendarMonthlyView: View {
    
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
                    NavigationLink(destination: destinationView(for: day)) {
                        CalendarDailyView(date: day)
                    }
                }
            }
        }
    }
    private func destinationView(for date: Date) -> some View {
        let calendarDetailItemVm = CalendarDetailItemViewModel(calendarItemModel: LogBookModel(userId: "1", formattedDate: "123", logBookText: "", latitude: 0.47586, longitude: 0.883626, imageUrl: "", containsLogBookEntry: false), date: date)
        return CalendarDetailItemView(calendarDetailItemVm: calendarDetailItemVm)
    }
}
#Preview{
    CalendarMonthlyView(month: Date())
}
