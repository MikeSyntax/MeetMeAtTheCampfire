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
    MapKitView(calendarDetailItemVm: CalendarDetailItemViewModel(calendarItemModel: LogBookModel(userId: "1", formattedDate: "", logBookText: "", latitude: 49.0069, longitude: 8.4037, imageUrl: "", containsLogBookEntry: false), dateVm: CalendarViewModel(date: Date())))
}
