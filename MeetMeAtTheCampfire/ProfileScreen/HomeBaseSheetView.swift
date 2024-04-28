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
    @AppStorage("isDarkMode") var isDark: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                MapKitNHomebaseView()
            }
        }
        .navigationTitle("Wähle Dein Homebase")
        .onAppear {
            profileScreenVm.requestHomebase()
        }
        .preferredColorScheme(isDark ? .dark : .light)
    }
}

#Preview {
    HomeBaseSheetView(profileScreenVm: ProfileScreenViewModel(user: UserModel(id: "", email: "", registeredTime: Date(), userName: "Hans", timeStampLastVisitChat: Date())))
}

struct MapKitNHomebaseView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack{
            Map() {
                UserAnnotation()
            }
            .mapControls {
                MapUserLocationButton()
            }
            .toolbar{
                Button("Übernehmen"){
                    dismiss()
                }
            }
        }
        .navigationTitle("Wähle Dein Homebase")
        .navigationBarTitleDisplayMode(.inline)
    }
}
