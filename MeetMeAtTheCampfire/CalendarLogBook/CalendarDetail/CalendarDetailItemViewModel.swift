//
//  CalendarDetailItemViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 20.03.24.
//

import Foundation
import MapKit
import SwiftUI

class CalendarDetailItemViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var mapCameraPosition: MapCameraPosition = MapCameraPosition.automatic
    @Published var lastLocation: CLLocation?
    @Published var latitude: Double
    @Published var longitude: Double
    @Published var logBookText: String = ""
    @Published var formattedDate: String = ""
    @Published var userId: String = ""
    
    let calendarItemModel: LogBookModel
    let calendarVm: CalendarViewModel
    
    private let locationManager = CLLocationManager()
    
    init(calendarItemModel: LogBookModel, calendarVm: CalendarViewModel) {
        
        self.calendarItemModel = calendarItemModel.self
        self.latitude = calendarItemModel.laditude
        self.longitude = calendarItemModel.longitude
        self.logBookText = calendarItemModel.logBookText
        self.formattedDate = calendarItemModel.formattedDate
        self.calendarVm = calendarVm.self
        
        super.init()
        locationManager.delegate = self
        
        self.userId = userId.self
        formattedDate = dateFormatter()
    }
    
    func createlogBookText(logBookText: String){
        guard let userId = FirebaseManager.shared.userId else {
            return
        }
        
        let newText = LogBookModel(userId: userId, formattedDate: formattedDate, logBookText: logBookText, laditude: self.latitude, longitude: self.longitude)
        
        do{
            try
            FirebaseManager.shared.firestore.collection("newLogEntry").addDocument(from: newText)
        } catch{
            print("Error creating newLogEntry: \(error)")
        }
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
    
    func requestLocation(){
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]){
        
        if let lastLocation = location.last {
            self.lastLocation = lastLocation
            self.mapCameraPosition = MapCameraPosition.camera(MapCamera(centerCoordinate: lastLocation.coordinate, distance: 5000))
            self.latitude = lastLocation.coordinate.latitude
            self.longitude = lastLocation.coordinate.longitude
            print("Deine ausgewählten Koordinaten sind \(self.latitude) und \(self.longitude)")
        }
    }
}
