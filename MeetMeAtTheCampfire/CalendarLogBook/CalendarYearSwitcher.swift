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

//#Preview {
//    CalendarYearSwitcher(year: $year)
//}
