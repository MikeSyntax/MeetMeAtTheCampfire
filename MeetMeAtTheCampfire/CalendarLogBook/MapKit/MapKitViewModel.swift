//
//  MapKitViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 21.03.24.
//

import Foundation
import MapKit
import SwiftUI

class MapKitViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var lastLocation: CLLocation?
    @Published var mapCameraPosition: MapCameraPosition = MapCameraPosition.automatic
    @Published var route: MKRoute?
    @Published var isLoading: Bool = false
    
    
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
                
                locationManager.delegate = self
            
    }
    
    func requestLocation(){
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]){
        if let lastLocation = location.last {
            self.lastLocation = lastLocation
            self.mapCameraPosition = MapCameraPosition.camera(MapCamera(centerCoordinate: lastLocation.coordinate, distance: 5000))
            // print(lastLocation.coordinate.latitude)
            // print(lastLocation.coordinate.longitude)
        }
    }
    
    @MainActor
    func fetchRoute(_ source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        Task{
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
            request.transportType = .automobile
            
            let result = try? await MKDirections(request: request).calculate()
            self.route = result?.routes.first
            self.isLoading = false
        }
    }
}
