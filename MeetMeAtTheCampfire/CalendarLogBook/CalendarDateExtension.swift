//
//  CalendarDateExtension.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 18.03.24.
//

import Foundation

extension Date {
    
    //Aktuelles Datum bekommen
    func get(_ component: Calendar.Component) -> Int {
        return Calendar.current.component(component, from: self)
    }
    
    func isWeekend() -> Bool {
        return Calendar.current.isDateInWeekend(self)
    }
    
    func isToday() -> Bool {
        return Calendar.current.isDate(Date(), inSameDayAs: self)
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
    
    func getAllMonths() -> [Date]{
        var months = [Date]()
        for i in 0..<12 {
            let month = Calendar.current.date(byAdding: .month, value: i, to: self)!
            months.append(month)
        }
        return months
    }
    
    func getNextYear() -> Date {
        return Calendar.current.date(byAdding: .year, value: +1, to: self)!
    }
    
    func getPreviousYear() -> Date {
        return Calendar.current.date(byAdding: .year, value: -1, to: self)!
    }
    
    func getAllDaysToNextMonth() -> [Date] {
        //Alle Tage in einem Arry gespeichert
        var days = [Date]()
        //mit der for Schleife wird geschaut welche Tage der Monat hat
        for i in 0..<getDaysCountOfMonth() {
            let day = Calendar.current.date(byAdding: .day, value: i, to: self)!
            //Die Tage werden dann der days hinzugefügt
            days.append(day)
        }
     return days
    }
    
    private func getDaysCountOfMonth() -> Int {
        return Calendar.current.range(of: .day, in: .month, for: self)!.count
    }
    
    
}
