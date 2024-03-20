//
//  WeekdayHeaderView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 18.03.24.
//

import SwiftUI

struct WeekdayHeaderView: View {
    @ObservedObject var dateVm: CalendarViewModel
    var weekdays = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"]
    
    var body: some View {
        LazyVGrid(columns: dateVm.columns, spacing: 25) {
            ForEach(weekdays, id: \.self) {
                weekday in
                Text(weekday)
            }
        }
    }
}
