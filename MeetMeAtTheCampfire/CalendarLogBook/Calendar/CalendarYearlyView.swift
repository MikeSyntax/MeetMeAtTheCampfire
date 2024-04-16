//
//  CalendarYearlyView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 18.03.24.
//

import SwiftUI

struct CalendarYearlyView: View {
    @ObservedObject var dateVm: CalendarViewModel
    @ObservedObject var calendarDetailItemVm: CalendarDetailItemViewModel
    @State var id: String = ""
    
    var body: some View {
        NavigationStack {
            VStack{
                Divider()
                ScrollView {
                    VStack {
                        WeekdayHeaderView(dateVm: dateVm)
                            .padding(.bottom)
                            .padding(.top)
                        ForEach(dateVm.getAllMonths(date: dateVm.date), id: \.self) { month in
                            CalendarMonthlyView(dateVm: CalendarViewModel(date: month), calendarDetailItemVm: calendarDetailItemVm)
                                .padding(.bottom, 50)
                                .id(dateVm.get(.month))
                            Divider()
                        }
                        
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    CalendarYearSwitcherView(dateVm: dateVm)
                }
            }
            .scrollPosition(id: $dateVm.scrollPosition)
            .navigationTitle("Logbuch \(CalendarUtils.getYearCaption(dateVm.date))")
            .scrollContentBackground(.hidden)
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
                    .ignoresSafeArea(.all)
            )
        }
        .onAppear {
            dateVm.scrollPosition = Calendar.current.component(.month, from: dateVm.date)
        }
    }
}


// Preview
struct CalendarYearlyView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarYearlyView(dateVm: CalendarViewModel(date: Date()), calendarDetailItemVm: CalendarDetailItemViewModel(calendarItemModel: LogBookModel(userId: "1", formattedDate: "", logBookText: "", latitude: 0.0, longitude: 0.0, imageUrl: "", containsLogBookEntry: false), dateVm: CalendarViewModel(date: Date())))
    }
}
