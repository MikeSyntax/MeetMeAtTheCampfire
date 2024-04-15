//
//  MapKitView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 19.03.24.
//

import SwiftUI
import MapKit

struct MapKitView: View {
    @ObservedObject var calendarDetailItemVm: CalendarDetailItemViewModel
    var body: some View {
        VStack{
            Map {
                Marker("Home", coordinate: CLLocationCoordinate2D(latitude: 49.0069, longitude: 8.40))
                    .tint(.orange)
                
                Annotation("Hier war ich", coordinate: CLLocationCoordinate2D(latitude: calendarDetailItemVm.latitude, longitude: calendarDetailItemVm.longitude)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.red)
                        Image(systemName: "car.side")
                    }
                }
            }
        }
    }
}

#Preview {
    MapKitView(calendarDetailItemVm: CalendarDetailItemViewModel(calendarItemModel: LogBookModel(userId: "1", formattedDate: "", logBookText: "", latitude: 49.0069, longitude: 8.4037, imageUrl: "", containsLogBookEntry: false), calendarVm: CalendarViewModel(date: Date())))
}






//struct MapKitView: View {
//    @ObservedObject var calendarDetailItemVm: CalendarDetailItemViewModel
//    var body: some View {
//            VStack{
//
//                Map(coordinateRegion: .constant(
//                            MKCoordinateRegion(
//                                center: CLLocationCoordinate2D(
//                                    latitude: calendarDetailItemVm.latitude,
//                                    longitude: calendarDetailItemVm.longitude
//                                ),
//                                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//                            )
//                        ), annotationItems: [AnnotationItem(coordinate: CLLocationCoordinate2D(latitude: calendarDetailItemVm.latitude, longitude: calendarDetailItemVm.longitude))]) { item in
//                            MapMarker(coordinate: item.coordinate, tint: .red)
//                        }
//                        .frame(width: 300, height: 200)
//                        .cornerRadius(10)
//            }
//        }
//}
//
//struct AnnotationItem: Identifiable {
//    var id = UUID()
//    var coordinate: CLLocationCoordinate2D
//}

//struct MapKitView: View {
//    @ObservedObject var calendarDetailItemVm: CalendarDetailItemViewModel
//
//    var body: some View {
//        MapView(coordinate: CLLocationCoordinate2D(latitude: calendarDetailItemVm.latitude, longitude: calendarDetailItemVm.longitude))
//    }
//}
//
//struct MapView: UIViewRepresentable {
//    let coordinate: CLLocationCoordinate2D
//
//    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
//        MKMapView()
//    }
//    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
//        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        let region = MKCoordinateRegion(center: coordinate, span: span)
//        uiView.setRegion(region, animated: true)
//
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = coordinate
//        uiView.addAnnotation(annotation)
//    }
//}


//let ref = Database.database().reference()
//ref.child("name").observe(.childAdded, with: { (snapshot) in
//
//let title = (snapshot.value as AnyObject!)!["Title"] as! String!
//let latitude = (snapshot.value as AnyObject!)!["Latitude"] as! String!
//let longitude = (snapshot.value as AnyObject!)!["Longitude"] as! String!
//
//let annotation = MKPointAnnotation()
//annotation.coordinate = CLLocationCoordinate2D(latitude: (Double(latitude!))!, longitude: (Double(longitude!))!)
//annotation.title = title
//self.map.addAnnotation(annotation)
//})
