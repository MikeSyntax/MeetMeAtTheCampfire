//
//  MapKitUserAnnotationView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 21.05.24.
//

//import Foundation
//import SwiftUI
//import MapKit
//
//struct MapKitUserAnnotationView: UIViewRepresentable {
//    
//    @AppStorage("homeLat") var homeBaseLatitude: Double = 49.849
//    @AppStorage("homeLong") var homeBaseLongitude: Double = 8.44
//    
//    func updateUIView(_ mapView: MKMapView, context: Context) {
//        
//        let span = MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
//        var homebaseCoordinate = CLLocationCoordinate2D()
//        homebaseCoordinate.latitude = homeBaseLatitude
//        homebaseCoordinate.longitude = homeBaseLongitude
//        let region = MKCoordinateRegion(center: homebaseCoordinate, span: span)
//        mapView.setRegion(region, animated: true)
//        
//    }
//    
//    func makeUIView(context: Context) -> MKMapView {
//        
//        let myMap = MKMapView(frame: .zero)
//        let longPress = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(EntireMapViewCoordinator.addAnnotation(gesture:)))
//        longPress.minimumPressDuration = 0.2
//        myMap.addGestureRecognizer(longPress)
//        myMap.delegate = context.coordinator
//        return myMap
//        
//    }
//    
//    func makeCoordinator() -> EntireMapViewCoordinator {
//        return EntireMapViewCoordinator(self)
//    }
//}
//
//class EntireMapViewCoordinator: NSObject, MKMapViewDelegate {
//    @AppStorage("coordinateLat") var coordinateLatitude: Double = 0.0
//    @AppStorage("coordinateLong") var coordinateLongitude: Double = 0.0
//    
//    var entireMapViewController: MapKitUserAnnotationView
//    
//    init(_ control: MapKitUserAnnotationView) {
//        self.entireMapViewController = control
//    }
//    
//    
//    @objc func addAnnotation(gesture: UIGestureRecognizer) {
//        
//        if gesture.state == .ended {
//            
//            if let mapView = gesture.view as? MKMapView {
//                let point = gesture.location(in: mapView)
//                let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
//                let annotation = MKPointAnnotation()
//                annotation.coordinate = coordinate
//                coordinateLatitude = coordinate.latitude
//                coordinateLongitude = coordinate.longitude
//                print("coordinate lat \(coordinate.latitude) und long \(coordinate.longitude)")
//                mapView.addAnnotation(annotation)
//            }
//        }
//    }
//}
//
