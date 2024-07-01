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
