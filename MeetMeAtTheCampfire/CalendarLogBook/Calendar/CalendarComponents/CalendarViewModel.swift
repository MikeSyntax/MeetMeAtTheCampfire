//
//  CalendarViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 18.03.24.
//

import Foundation
import SwiftUI

class CalendarViewModel: ObservableObject {
    @Published var date: Date
    @Published var scrollPosition: Int? = nil
    @Published var weekendColor = Color(cgColor: CGColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1))
    @Published var columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    init(date: Date){
        self.date = date
    }
    
    func get(_ component: Calendar.Component) -> Int {
        return Calendar.current.component(component, from: self.date)
    }
    
    func isWeekend(date: Date) -> Bool {
        return Calendar.current.isDateInWeekend(self.date)
    }
    
    func isToday(date: Date) -> Bool {
        return Calendar.current.isDate(Date(), inSameDayAs: self.date)
    }
    
    func getWeekday(date: Date) -> Int {
        let weekday = Calendar.current.component(.weekday, from: self.date) - 2
        if weekday < 0 {
            return 7 + weekday
        }
        return weekday
    }
    
//    func getFirstDateOfYear(date: Date) -> Date {
//        return startOfYear(date: self.date)
//    }
   
    func getAllMonths(date: Date) -> [Date]{
        var months = [Date]()
        for thisMonth in 0..<12 {
            let month = Calendar.current.date(byAdding: .month, value: thisMonth, to: date)!
            months.append(month)
        }
        return months
    }
    
//    func startOfYear(date: Date) -> Date {
//        return Calendar.current.startOfYear(date: date)
//    }
    
    func getAllDaysToNextMonth(from date: Date) -> [Date] {
        //Alle Tage in einem Array gespeichert
        var days = [Date]()
        //mit der for Schleife wird geschaut welche Tage der Monat hat
        for thisDay in 0..<getDaysCountOfMonth(date: date) {
            let day = Calendar.current.date(byAdding: .day, value: thisDay, to: date)!
            //Die Tage werden dann der days hinzugefügt
            days.append(day)
        }
        return days
    }
    
    func getDaysCountOfMonth(date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)!.count
    }
    
    func getNextYear(date: Date) -> Date {
        return Calendar.current.date(byAdding: .year, value: 1, to: date)!
    }
    
    func getPreviousYear(date: Date) -> Date {
        return Calendar.current.date(byAdding: .year, value: -1, to: date)!
    }
}
