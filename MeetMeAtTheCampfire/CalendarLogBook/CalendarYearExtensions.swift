//
//  CalendarYearExtensions.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 18.03.24.
//

import Foundation

extension Calendar {
    
    func startOfYear(date: Date) -> Date {
        //Methode für den Start vom Jahr
        return self.date(from: self.dateComponents([.year, .year], from: date))!
    }
}