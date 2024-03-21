//
//  MapKitView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 19.03.24.
//

import SwiftUI
import MapKit

struct MapKitView: View {
    @StateObject var mapKitVm = MapKitViewModel()
//    @ObservedObject var calenderDetailVm: CalendarDetailItemViewModel
    
    var body: some View {
        Map(position: $mapKitVm.mapCameraPosition) {
//            Marker("Zuhause", coordinate: CLLocationCoordinate2D(latitude: 49.0069, longitude: 8.4037))
//            Annotation("Hier hin", coordinate: CLLocationCoordinate2D(latitude: 50.0, longitude: 8.25)){
//                Image(systemName: "beach.umbrella")
//                    .padding(5)
//                    .background(.red)
//                    .clipShape(Circle())
//            }
            UserAnnotation()
        }
        .mapControls {
            MapUserLocationButton()
        }
       // .frame(width: 300, height: 300)
        .padding()
        .onAppear {
            mapKitVm.requestLocation()
        }
        
        //Wegberechnung von einem Start zum Ziel
//        Map {
//            if let route = mapKitVm.route {
//                MapPolyline(route.polyline)
//                    .stroke(.red, lineWidth: 6)
//            }
//        }
//        .onAppear{
//            self.mapKitVm.fetchRoute(.init(latitude: 49.0047, longitude: 8.406), to: .init(latitude: 50.0, longitude: 8.25))
//        }
//        .padding()
    }
}

#Preview {
    MapKitView(/*/ calenderDetailVm: CalendarDetailItemViewModel(calendarItemModel: LogBookModel(userId: "1", formattedDate: "", logBookText: "Rudern", laditude: 0.0, longitude: 0.0), calendarVm: CalendarViewModel(date: Date()))*/)
}

