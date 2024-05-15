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

#Preview{
    MapKitNewEntryView()
}
