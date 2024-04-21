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
            VStack{
                Divider()
                ScrollView {
                    VStack{
                        WeekdayHeaderView()
                            .padding(.bottom)
                            .padding(.top)
                        
                        ForEach(year.getAllMonths(), id:  \.self) { month in
                            CalendarMonthlyView(/*calendarDetailItemVm: calendarDetailItemVm, */month: month)
                                .padding(.bottom, 50)
                                .id(month.get(.month))
                            
                            Divider()
                                .background(.gray)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing){
                    YearSwitcher(year: $year)
                }
            }
            .onAppear {
                scrollPosition = Int(Date().get(.month))
            }
            .scrollPosition(id: $scrollPosition)
            .navigationTitle("Logbuch \(CalendarUtils.getYearCaption(year))")
            .scrollContentBackground(.hidden)
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
                    .ignoresSafeArea(.all)
            )
        }
    }
}

#Preview{
    CalendarYearlyView()
}

private struct WeekdayHeaderView: View {
    
    private var weekdays = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"]
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View{
        LazyVGrid(columns: columns, spacing: 25){
            ForEach(weekdays, id: \.self) { weekday in
                Text(weekday)
            }
        }
    }
}

private struct YearSwitcher: View {
    @Binding var year: Date
    
    var body: some View{
        HStack{
            Button("-"){
                year = year.getPreviousYear()
            }
            Text(CalendarUtils.getYearCaption(year))
            Button("+"){
                year = year.getNextYear()
            }
        }
    }
}
