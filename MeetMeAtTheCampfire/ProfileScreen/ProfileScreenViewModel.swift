//
//  ProfileScreenViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 20.04.24.
//

import Foundation
import FirebaseFirestore
import MapKit
import SwiftUI

final class ProfileScreenViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var chatLikedViewModels: [ChatItemViewModel] = []
    @Published var homebaseCameraPosition: MapCameraPosition = MapCameraPosition.automatic
    @Published var lastHomebase: CLLocation?
    @AppStorage("homeLat") var homeBaseLatitude: Double = 49.849
    @AppStorage("homeLong") var homeBaseLongitude: Double = 8.44
    private let locationHomebase = CLLocationManager()
    private var listener: ListenerRegistration? = nil
    
    var user: UserModel
    
    init(user: UserModel){
        self.user = user
        
        super.init()
        locationHomebase.delegate = self
    }
    
    @MainActor
    func readLikedMessages() {
        guard let userId = FirebaseManager.shared.userId else {
            return
        }
        self.listener = FirebaseManager.shared.firestore.collection("messages")
            .whereField("isLikedByUser", arrayContains: userId)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error reading likedMessages: \(error)")
                    return
                }
                guard let documents = querySnapshot?.documents else {
                    print("Query Snapshot likedMessages is empty")
                    return
                }
                let messages = documents.compactMap { document in
                    try? document.data(as: ChatModel.self)
                }
                let sortedMessages = messages.sorted { $0.timeStamp < $1.timeStamp }
                let chatLikedViewModels = sortedMessages.map { message in
                    return ChatItemViewModel(chatDesign: message)
                }
                self.chatLikedViewModels = chatLikedViewModels
            }
    }
    
    func removeListener(){
        self.listener = nil
        self.chatLikedViewModels = []
    }
    
    @MainActor
    func stopLocationRequest(){
        self.locationHomebase.stopUpdatingLocation()
    }
    
    @MainActor
    func requestHomebase(){
        self.locationHomebase.requestWhenInUseAuthorization()
        self.locationHomebase.startUpdatingLocation()
    }
    
    @MainActor
    func locationManager(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]){
        if let lastHomebase = location.last {
            self.lastHomebase = lastHomebase
            self.homebaseCameraPosition = MapCameraPosition.camera(MapCamera(centerCoordinate: lastHomebase.coordinate, distance: 5000))
            self.homeBaseLatitude = lastHomebase.coordinate.latitude
            self.homeBaseLongitude = lastHomebase.coordinate.longitude
            print("homebase choosen \(self.homeBaseLatitude) and \(self.homeBaseLongitude)")
        }
    }
}
