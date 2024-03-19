//
//  CalendarYearlyView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 18.03.24.
//

import SwiftUI

struct CalendarYearlyView: View {
    @ObservedObject var dateVm: CalendarViewModel
    @State var id: String = ""
    
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
                            .id(dateVm.get(.month))
                        
                        Divider()
                    }
                }
            }
            .onAppear {
                dateVm.scrollPosition = Calendar.current.component(.month, from: dateVm.date)
            }
          .scrollPosition(id: $dateVm.scrollPosition)
            .navigationTitle("Logbuch \(CalendarUtils.getYearCaption(dateVm.date))")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    CalendarYearSwitcherView(dateVm: dateVm)
                }
            }
        }
    }
}

#Preview {
    CalendarYearlyView(dateVm: CalendarViewModel(date: Date()))
}
