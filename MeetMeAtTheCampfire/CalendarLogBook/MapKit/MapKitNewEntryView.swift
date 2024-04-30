//
//  MapKitNewEntryView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 22.03.24.
//

import SwiftUI
import MapKit

struct MapKitNewEntryView: View {
    var body: some View {
        VStack{
            Map() {
                UserAnnotation()
            }
            .mapControls {
                MapUserLocationButton()
            }
        }
        .ignoresSafeArea()
    }
}

//struct ContentView: View {
//    var body: some View {
//
//        GeometryReader { proxy in
//            VStack(spacing: 0.0) {
//                ZStack {
//                    Color.blue
//                    Text("MapView here!") // MapView()
//                }


//                .frame(height: proxy.size.height/2)
//                ZStack {
//                    Color.red
//                    MapKitNewEntryView()
//                }
//                .frame(height: proxy.size.height/2)
//            }
//        }
//        .ignoresSafeArea()
//    }
//}

//import SwiftUI
//import MapKit
//
//struct Location: Identifiable {
//    let id = UUID()
//    let name: String
//    let coordinate: CLLocationCoordinate2D
//}
//
//struct ContentView: View {
//    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
//
//    let locations = [
//        Location(name: "Buckingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
//        Location(name: "Tower of London", coordinate: CLLocationCoordinate2D(latitude: 51.508, longitude: -0.076))
//    ]
//
//    var body: some View {
//        Map(coordinateRegion: $region, annotationItems: locations) { location in
//            MapAnnotation(coordinate: location.coordinate) {
//                Circle()
//                    .stroke(.red, lineWidth: 3)
//                    .frame(width: 44, height: 44)
//            }
//        }
//        .navigationTitle("Map")
//        .edgesIgnoringSafeArea(.all)
//    }
//}
//
#Preview{
    MapKitNewEntryView()
}
