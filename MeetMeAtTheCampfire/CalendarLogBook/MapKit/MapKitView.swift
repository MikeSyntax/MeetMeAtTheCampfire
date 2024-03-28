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
                Map() {
                    Annotation("Hier war ich", coordinate: CLLocationCoordinate2D(latitude: calendarDetailItemVm.latitude, longitude: calendarDetailItemVm.longitude)){
                        Image(systemName: "beach.umbrella")
                            .padding(5)
                            .background(.red)
                            .clipShape(Circle())
                    }
                }
                .onAppear {
                    //todo read Daten aus Firebase
                }
            }
        }
}

