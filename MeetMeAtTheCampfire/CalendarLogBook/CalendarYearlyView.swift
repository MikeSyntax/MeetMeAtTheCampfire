//
//  CalendarYearlyView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 18.03.24.
//

import SwiftUI

struct CalendarYearlyView: View {

    @State private var year = Date().getFirstDateOfYear()
    @State private var scrollPosition: Int? = nil
    
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack{
                    WeekdayHeaderView()
                        .padding(.bottom)
                        .padding(.top)
                    ForEach(year.getAllMonths(), id: \.self) {
                        month in
                        CalendarMonthlyView(month: month)
                            .padding(.bottom, 50)
                        //jedem Monat eine eindeutige Id zuweisen für die scrollPosition
                            .id(month.get(.month))
                        Divider()
                    }
                }
            }
            .onAppear{
                scrollPosition = Int(Date().get(.month))
            }
            .scrollPosition(id: $scrollPosition)
            .navigationTitle("Tagebuch \(CalendarUtils.getYearCaption(year))")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing){
                    CalendarYearSwitcher(year: $year)
                }
            }
        }
    }
}

private struct WeekdayHeaderView: View {
    private var weekdays = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 25) {
            ForEach(weekdays, id: \.self) {
                weekday in
                Text(weekday)
            }
        }
    }
}



#Preview {
    CalendarYearlyView()
}
