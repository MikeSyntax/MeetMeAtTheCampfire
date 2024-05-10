//
//  HomeBaseSheetView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 28.04.24.
//
import Foundation
import SwiftUI
import MapKit

struct HomeBaseSheetView: View {
    
    @ObservedObject var profileScreenVm: ProfileScreenViewModel
    @AppStorage("homeLat") var homeBaseLatitude: Double = 49.849
    @AppStorage("homeLong") var homeBaseLongitude: Double = 8.44
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack{
            VStack{
                Map() {
                    UserAnnotation()
                }
                .mapControls {
                    MapUserLocationButton()
                }
            }
            .toolbar{
                Button("Übernehmen"){
                    profileScreenVm.stopLocationRequest()
                    dismiss()
                }
            }
            .navigationTitle("Wähle Dein Homebase")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                profileScreenVm.requestHomebase()
            }
        }
        .background(Color(UIColor.systemBackground))
        .ignoresSafeArea()
    }
}

#Preview {
    HomeBaseSheetView(profileScreenVm: ProfileScreenViewModel(user: UserModel(id: "", email: "", registeredTime: Date(), userName: "Hans", timeStampLastVisitChat: Date(), isActive: true, imageUrl: "")))
}

