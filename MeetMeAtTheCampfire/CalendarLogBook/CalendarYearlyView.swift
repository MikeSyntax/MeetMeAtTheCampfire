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
                    WeekdayHeader()
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

#Preview {
    CalendarYearlyView()
}



//import SwiftUI
//
//struct CalendarYearlyView: View {
//    
//    @ObservedObject var dateVm: DateViewModel
//    @State var year: Date
//    @State private var scrollPosition: Int?
//    
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack {
//                    WeekdayHeader()
//                        .padding(.bottom)
//                        .padding(.top)
//                    ForEach(dateVm.getAllMonths(date: year), id: \.self) { month in
//                        CalendarMonthlyView(dateVm: dateVm, month: month)
//                            .padding(.bottom, 50)
//                            .id(month)
//                        Divider()
//                    }
//                }
//            }
//            .onAppear {
//                scrollPosition = Calendar.current.component(.month, from: Date())
//            }
//            .scrollPosition(id: $scrollPosition)
//            .navigationTitle("Tagebuch \(CalendarUtils.getYearCaption(year))")
//                        .toolbar {
//                            ToolbarItem(placement: .topBarTrailing) {
//                                CalendarYearSwitcher(year: $year)
//                            }
//        }
//    }
//}
//}
//
//struct CalendarYearlyView_Previews: PreviewProvider {
//    @State static var year = Date()
//    
//    static var previews: some View {
//        CalendarYearlyView(dateVm: DateViewModel(), year: year)
//    }
//}
