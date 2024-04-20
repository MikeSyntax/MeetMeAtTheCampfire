//
//  CalendarExtensions.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 18.03.24.
//

import Foundation

extension Date {
    
    func get(_ component: Calendar.Component) -> Int {
        return Calendar.current.component(component, from: self)
    }
    
    func isWeekend() -> Bool {
        return Calendar.current.isDateInWeekend(self)
    }
    
    func isToday() -> Bool {
        return Calendar.current.isDate(Date(), inSameDayAs: self)
    }
    
    func getAllDaysToNextMonth() -> [Date] {
        var days = [Date]()
        for i in 0..<getDaysCountOfMonth(){
          let day = Calendar.current.date(byAdding: .day, value: i, to: self)!
            days.append(day)
        }
        return days
    }
    
    func getDaysCountOfMonth() -> Int {
        return Calendar.current.range(of: .day, in: .month, for: self)!.count
    }
    
    func getWeekday() -> Int {
        let weekday = get(.weekday) - 2
        if weekday < 0 {
            return 7 + weekday
        }
        return weekday
    }
    
    func getFirstDateOfYear() -> Date {
        return Calendar.current.startOfYear(date: self)
    }
    
    func getAllMonths() -> [Date] {
        var months = [Date]()
        for i in 0..<12 {
            let month = Calendar.current.date(byAdding: .month, value: i, to: self)!
            months.append(month)
        }
        return months
    }
    
    func getNextYear() -> Date {
        Calendar.current.date(byAdding: .year, value: 1, to: self)!
    }
    
    func getPreviousYear() -> Date {
        Calendar.current.date(byAdding: .year, value: -1, to: self)!
    }
}
