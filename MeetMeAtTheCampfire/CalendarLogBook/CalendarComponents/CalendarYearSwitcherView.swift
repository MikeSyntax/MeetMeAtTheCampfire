//
//  CalendarYearSwitcherView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 18.03.24.
//

import SwiftUI
import Foundation

struct CalendarYearSwitcherView: View {
    @ObservedObject var dateVm: CalendarViewModel
    //@Binding var year: Date
    
    var body: some View {
        HStack {
            Button("-") {
                dateVm.date = Calendar.current.date(byAdding: .year, value: -1, to: dateVm.date)!
            }
            Text(CalendarUtils.getYearCaption(dateVm.date))
            Button("+") {
                dateVm.date = Calendar.current.date(byAdding: .year, value: +1, to: dateVm.date)!
            }
        }
    }
}
