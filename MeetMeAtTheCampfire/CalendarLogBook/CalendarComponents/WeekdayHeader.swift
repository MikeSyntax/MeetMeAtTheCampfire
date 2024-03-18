//
//  WeekdayHeader.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 18.03.24.
//

import SwiftUI

struct WeekdayHeader: View {
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
