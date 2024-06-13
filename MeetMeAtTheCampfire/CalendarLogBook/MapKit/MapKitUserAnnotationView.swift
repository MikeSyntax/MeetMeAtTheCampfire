//
//  MapKitUserAnnotationView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 21.05.24.
//

import Foundation
import SwiftUI
import MapKit

struct MapKitUserAnnotationView: UIViewRepresentable {

    @Binding var latitude: Double
    @Binding var longitude: Double

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        let longPressGesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.addAnnotation(gesture:)))
        longPressGesture.minimumPressDuration = 0.2
        mapView.addGestureRecognizer(longPressGesture)

        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        // Entferne alle bestehenden Annotationen
        view.removeAnnotations(view.annotations)
        
        // Erstelle und füge die Annotation für den aktuellen Standort hinzu
        let currentLocationAnnotation = CurrentLocationAnnotation(coordinate: coordinate)
        view.addAnnotation(currentLocationAnnotation)
        view.setCenter(coordinate, animated: true)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapKitUserAnnotationView

        init(_ parent: MapKitUserAnnotationView) {
            self.parent = parent
        }

        @objc func addAnnotation(gesture: UILongPressGestureRecognizer) {
            if gesture.state == .began {
                let location = gesture.location(in: gesture.view as? MKMapView)
                let coordinate = (gesture.view as? MKMapView)?.convert(location, toCoordinateFrom: gesture.view)

                if let coordinate = coordinate {
                    // Füge eine neue Annotation für den ausgewählten Standort hinzu
                    let selectedLocationAnnotation = MKPointAnnotation()
                    selectedLocationAnnotation.coordinate = coordinate
                    (gesture.view as? MKMapView)?.addAnnotation(selectedLocationAnnotation)

                    parent.latitude = coordinate.latitude
                    parent.longitude = coordinate.longitude
                }
            }
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is CurrentLocationAnnotation {
                let identifier = "CurrentLocation"
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
                if annotationView == nil {
                    annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    annotationView?.canShowCallout = true
                    annotationView?.markerTintColor = .blue
                    annotationView?.glyphImage = UIImage(systemName: "location.fill")
                } else {
                    annotationView?.annotation = annotation
                }
                return annotationView
            } else {
                let identifier = "SelectedLocation"
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
                if annotationView == nil {
                    annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    annotationView?.canShowCallout = true
                    
                } else {
                    annotationView?.annotation = annotation
                }
                return annotationView
            }
        }
    }
}

// Benutzerdefinierte Annotation für den aktuellen Standort
class CurrentLocationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
















//Beste aktuelle Version
//struct MapKitUserAnnotationView: UIViewRepresentable {
//
//    @Binding var latitude: Double
//    @Binding var longitude: Double
//
//    func makeUIView(context: Context) -> MKMapView {
//        let mapView = MKMapView()
//        mapView.delegate = context.coordinator
//
//        let longPressGesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.addAnnotation(gesture:)))
//        longPressGesture.minimumPressDuration = 0.2
//        mapView.addGestureRecognizer(longPressGesture)
//
//        return mapView
//    }
//
//    func updateUIView(_ view: MKMapView, context: Context) {
//
//
//        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = coordinate
//        view.addAnnotation(annotation)
//        view.setCenter(coordinate, animated: true)
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, MKMapViewDelegate {
//        var parent: MapKitUserAnnotationView
//
//        init(_ parent: MapKitUserAnnotationView) {
//            self.parent = parent
//        }
//
//        @objc func addAnnotation(gesture: UILongPressGestureRecognizer) {
//            if gesture.state == .began {
//                let location = gesture.location(in: gesture.view as? MKMapView)
//                let coordinate = (gesture.view as? MKMapView)?.convert(location, toCoordinateFrom: gesture.view)
//
//                if let coordinate = coordinate {
//                    parent.latitude = coordinate.latitude
//                    parent.longitude = coordinate.longitude
//                }
//            }
//        }
//    }
//}





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

