//
//  CalendarUtils.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 18.03.24.
//

import Foundation

class CalendarUtils {
    
    private static var monthFormatter = createMonthFormatter()
    
    
    static func getMonthCaption(_ date: Date) -> String {
        return monthFormatter.string(from: date)
    }
    
    private static func createMonthFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }
    
    
    
    private static var yearFormatter = createYearFormatter()
    
    static func getYearCaption(_ date: Date) -> String {
        return yearFormatter.string(from: date)
    }
    
    private static func createYearFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        return formatter
    }
}