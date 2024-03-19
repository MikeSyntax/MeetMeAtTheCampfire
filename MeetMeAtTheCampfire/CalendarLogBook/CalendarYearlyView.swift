//
//  CalendarYearlyView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 18.03.24.
//

import SwiftUI
//struct CalendarYearlyView: View {
//
//    @State private var year = Date().getFirstDateOfYear()
//    @State private var scrollPosition: Int? = nil
//
//    var body: some View {
//        NavigationStack{
//            ScrollView {
//                VStack{
//                    WeekdayHeaderView()
//                        .padding(.bottom)
//                        .padding(.top)
//                    ForEach(year.getAllMonths(), id: \.self) {
//                        month in
//                        CalendarMonthlyView(month: month)
//                            .padding(.bottom, 50)
//                        //jedem Monat eine eindeutige Id zuweisen für die scrollPosition
//                            .id(month.get(.month))
//                        Divider()
//                    }
//                }
//            }
//            .onAppear{
//                scrollPosition = Int(Date().get(.month))
//            }
//            .scrollPosition(id: $scrollPosition)
//            .navigationTitle("Tagebuch \(CalendarUtils.getYearCaption(year))")
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing){
//                    CalendarYearSwitcherView(year: $year)
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    CalendarYearlyView()
//}


struct CalendarYearlyView: View {
    @ObservedObject var dateVm: CalendarViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    WeekdayHeaderView(dateVm: dateVm)
                        .padding(.bottom)
                        .padding(.top)
                    ForEach(dateVm.getAllMonths(date: dateVm.date), id: \.self) { month in
                        CalendarMonthlyView(dateVm: CalendarViewModel(date: month))
                            .padding(.bottom, 50)
                            .id(month)
                        Divider()
                    }
                }
            }
            .onAppear {
                dateVm.scrollPosition = Calendar.current.component(.month, from: dateVm.date)
            }
          .scrollPosition(id: $dateVm.scrollPosition)
            .navigationTitle("Tagebuch \(CalendarUtils.getYearCaption(dateVm.date))")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    CalendarYearSwitcherView(dateVm: dateVm)
                }
            }
        }
    }
}
