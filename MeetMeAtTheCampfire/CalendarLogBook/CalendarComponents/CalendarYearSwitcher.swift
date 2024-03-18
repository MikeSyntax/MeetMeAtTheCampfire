//
//  CalendarYearSwitcher.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 18.03.24.
//

import SwiftUI

struct CalendarYearSwitcher: View {
    @Binding var year: Date
    
    var body: some View {
        HStack {
            Button("-") {
                year = Calendar.current.date(byAdding: .year, value: -1, to: year)!
            }
            Text(CalendarUtils.getYearCaption(year))
            Button("+") {
                year = Calendar.current.date(byAdding: .year, value: 1, to: year)!
            }
        }
    }
}

//import SwiftUI
//
//struct CalendarYearSwitcher: View {
//    @State private var year: Date
//
//    var body: some View {
//        HStack {
//            Button("-") {
//                year = Calendar.current.date(byAdding: .year, value: -1, to: year)!
//            }
//            Text(CalendarUtils.getYearCaption(year))
//            Button("+") {
//                year = Calendar.current.date(byAdding: .year, value: 1, to: year)!
//            }
//        }
//    }
//}
