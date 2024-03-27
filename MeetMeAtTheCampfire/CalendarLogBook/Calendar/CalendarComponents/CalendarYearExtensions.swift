//
//  CalendarYearExtensions.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 18.03.24.
//

import Foundation

extension Calendar {
    
    func startOfYear(date: Date) -> Date {
        let calender = Calendar.current
        let currentDate = Date()
        let components = calender.dateComponents([.year], from: currentDate)
        return calender.date(from: components) ?? Date()
    }
}
