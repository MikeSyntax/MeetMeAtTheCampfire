//
//  MapKitView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 19.03.24.
//

import SwiftUI
import MapKit

struct MapKitView: View {
    
    @AppStorage("homeLat") var homeBaseLatitude: Double = 49.849
    @AppStorage("homeLong") var homeBaseLongitude: Double = 8.44
    @ObservedObject var calendarDetailItemVm: CalendarDetailItemViewModel
    
    var body: some View {
        Map {
            Annotation("zuHause", 
                       coordinate: CLLocationCoordinate2D(
                        latitude: homeBaseLatitude,
                        longitude: homeBaseLongitude)) {
                ZStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.red)
                        .font(.system(size: 30))
                }
            }
            Annotation("Hier war ich", 
                       coordinate: CLLocationCoordinate2D(
                        latitude: calendarDetailItemVm.latitude,
                        longitude: calendarDetailItemVm.longitude)) {
                ZStack {
                    Image(systemName: "figure.wave")
                        .foregroundColor(.red)
                        .font(.system(size: 30))
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview{
    MapKitView(calendarDetailItemVm: CalendarDetailItemViewModel(calendarItemModel: LogBookModel(userId: "1", formattedDate: "1", logBookText: "", latitude: 48.0069, longitude: 0.0, imageUrl: "", containsLogBookEntry: false), date: Date()))
}
