//
//  MapKitViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 21.03.24.
//

//import Foundation
//import MapKit
//import SwiftUI
//
//class MapKitViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
//    @Published var lastLocation: CLLocation?
//    @Published var latitude: Double = 0.85
//    @Published var longitude: Double = 0.85
//    @Published var mapCameraPosition: MapCameraPosition = MapCameraPosition.automatic
//    //@Published var route: MKRoute?
//    //@Published var isLoading: Bool = false
//    //@Published var savedLocation: CLLocation?
//    private let locationManager = CLLocationManager()
//    
//    init(latitude: Double, longitude: Double) {
//        
//        super.init()
//        locationManager.delegate = self
//    }
//    
//    func requestLocation(){
//        self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.startUpdatingLocation()
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]){
//        
//        if let lastLocation = location.last {
//            self.lastLocation = lastLocation
//            self.mapCameraPosition = MapCameraPosition.camera(MapCamera(centerCoordinate: lastLocation.coordinate, distance: 5000))
//            self.latitude = lastLocation.coordinate.latitude
//            self.longitude = lastLocation.coordinate.longitude
//            print(self.latitude, self.longitude)
//        }
//    }
//}
////    @MainActor
////    func fetchRoute(_ source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
////        Task{
////            let request = MKDirections.Request()
////            request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
////            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
////            request.transportType = .automobile
////
////            let result = try? await MKDirections(request: request).calculate()
////            self.route = result?.routes.first
////            self.isLoading = false
////        }
////    }
//
