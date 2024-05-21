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
//        func updateUIView(_ mapView: MKMapView, context: Context) {
//
//            let span = MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
//            var chicagoCoordinate = CLLocationCoordinate2D()
//            chicagoCoordinate.latitude = 41.878113
//            chicagoCoordinate.longitude = -87.629799
//            let region = MKCoordinateRegion(center: chicagoCoordinate, span: span)
//            mapView.setRegion(region, animated: true)
//
//        }
//
//        func makeUIView(context: Context) -> MKMapView {
//
//            let myMap = MKMapView(frame: .zero)
//            let longPress = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(EntireMapViewCoordinator.addAnnotation(gesture:)))
//            longPress.minimumPressDuration = 1
//            myMap.addGestureRecognizer(longPress)
//            myMap.delegate = context.coordinator
//            return myMap
//
//        }
//
//    func makeCoordinator() -> EntireMapViewCoordinator {
//        return EntireMapViewCoordinator(self)
//    }
//
//    class EntireMapViewCoordinator: NSObject, MKMapViewDelegate {
//
//        var entireMapViewController: MapKitUserAnnotationView
//
//        init(_ control: MapKitUserAnnotationView) {
//          self.entireMapViewController = control
//        }
//
//
//        @objc func addAnnotation(gesture: UIGestureRecognizer) {
//
//            if gesture.state == .ended {
//
//                if let mapView = gesture.view as? MKMapView {
//                let point = gesture.location(in: mapView)
//                let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
//                let annotation = MKPointAnnotation()
//                annotation.coordinate = coordinate
//                    print("coordinate lat \(coordinate.latitude) und long \(coordinate.longitude)")
//                mapView.addAnnotation(annotation)
//                }
//            }
//        }
//    }
//}
