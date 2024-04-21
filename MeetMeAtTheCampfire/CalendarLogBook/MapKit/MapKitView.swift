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
                Annotation("zuHause", coordinate: CLLocationCoordinate2D(latitude: 49.0069, longitude: 8.40)) {
                                    ZStack {
                                        Image(systemName: "mappin.and.ellipse")
                                            .foregroundColor(.red)
                                            .font(.system(size: 20))
                                    }
                                }
                Annotation("Hier war ich", coordinate: CLLocationCoordinate2D(latitude: calendarDetailItemVm.latitude, longitude: calendarDetailItemVm.longitude)) {
                    ZStack {
                        Image(systemName: "figure.wave")
                            .foregroundColor(.red)
                            
                    }
                }
            }
        }
    }
}

