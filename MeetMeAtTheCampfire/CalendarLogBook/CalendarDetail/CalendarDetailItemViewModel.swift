//
//  CalendarDetailItemViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 20.03.24.
//

import Foundation

class CalendarDetailItemViewModel: ObservableObject {
    
    let calendarVm: CalendarViewModel
    
    @Published var latitude: Double = 52.0
    @Published var longitude: Double = 8.25
    @Published var logBookText: String = ""
    @Published var formattedDate: String = ""
    
    let calendarItemModel: LogBookModel
    
    init(calendarItemModel: LogBookModel, calendarVm: CalendarViewModel) {
        
        self.calendarItemModel = calendarItemModel.self
        self.latitude = calendarItemModel.laditude
        self.longitude = calendarItemModel.longitude
        self.logBookText = calendarItemModel.logBookText
        self.formattedDate = calendarItemModel.formattedDate
        self.calendarVm = calendarVm.self
        
        formattedDate = dateFormatter()
        
    }
    
    func createlogBookText(){
        
        
    }
    
    func readLogBookText(){
        
        
    }
    
    func updateLogBookText(){
        
        
    }
    
    func dateFormatter() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: calendarVm.date)
    }
}
