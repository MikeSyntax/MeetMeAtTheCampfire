//
//  CalendarDetailItemViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 20.03.24.
//

import Foundation
import FirebaseFirestore
import MapKit
import SwiftUI

class CalendarDetailItemViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    //Leeres Array mit LogBockModels
    @Published var newEntryLogs: [LogBookModel] = []
    //alle published Variablen
    @Published var mapCameraPosition: MapCameraPosition = MapCameraPosition.automatic
    @Published var lastLocation: CLLocation?
    @Published var latitude: Double
    @Published var longitude: Double
    @Published var logBookText: String = ""
    @Published var formattedDate: String = ""
    @Published var userId: String = ""
    @Published var imageUrl: String = ""
    @Published var selectedImage: UIImage?
    @Published var readImages: [String] = []
    @Published var containsLogBookEntry: Bool = false
    
    //Listener
    private var listener: ListenerRegistration? = nil
    let calendarItemModel: LogBookModel
    let dateVm: CalendarViewModel
    
    private let locationManager = CLLocationManager()
    
    init(calendarItemModel: LogBookModel, dateVm: CalendarViewModel) {
        
        self.calendarItemModel = calendarItemModel.self
        self.latitude = calendarItemModel.latitude
        self.longitude = calendarItemModel.longitude
        self.logBookText = calendarItemModel.logBookText
        self.formattedDate = calendarItemModel.formattedDate
        self.dateVm = dateVm.self
        self.imageUrl = calendarItemModel.imageUrl
        self.containsLogBookEntry = calendarItemModel.containsLogBookEntry
        
        super.init()
        locationManager.delegate = self
        
        self.userId = userId.self
        formattedDate = dateFormatter()
    }
    
    deinit{
        removeListener()
    }
    
    ///create new data logBookText with image
    func createlogBookText(logBookText: String){
        guard let uploadImage = selectedImage else {
            return
        }
        
        let imageData = uploadImage.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            return
        }
        //create path for storage and firestore
        let fileRef = FirebaseManager.shared.storage.reference().child("/images/\(UUID().uuidString).jpg")
        
        fileRef.putData(imageData!, metadata: nil){
            metadata, error in
            
            if let error {
                print("Error loading metadata \(error)")
                return
            }
            
            if error == nil && metadata != nil {
                print("Image upload succesfull")
            }
            
            //create new data for firestore
            guard let userId = FirebaseManager.shared.userId else {
                return
            }
            
            fileRef.downloadURL { url, error in
                guard let imageUrl = url?.absoluteString else {
                    print("URL WAR KACKE")
                    return
                }
                self.imageUrl = imageUrl
                let newText = LogBookModel(
                    userId: userId,
                    formattedDate: self.formattedDate,
                    logBookText: logBookText,
                    latitude: self.latitude,
                    longitude: self.longitude,
                    imageUrl: imageUrl,
                    containsLogBookEntry: true
                )
                
                do{
                    try
                    FirebaseManager.shared.firestore.collection("newLogEntry").addDocument(from: newText)
                    print("Creating newLogEntry succesfull")
                } catch{
                    print("Error creating newLogEntry: \(error)")
                }
            }
        }
    }
    
    //Read all Data from Firebase
    @MainActor
    func readLogBookText(formattedDate: String){
        guard let userId = FirebaseManager.shared.userId else {
            return
        }
        //SnapshotListener
        self.listener = FirebaseManager.shared.firestore.collection("newLogEntry")
            .whereField("userId", isEqualTo: userId)
            .whereField("formattedDate", isEqualTo: formattedDate)
            .addSnapshotListener {
                querySnapshot, error in
                if let error {
                    print("Error reading newLogEntrys \(error)")
                    return
                }
                //Load all images in querySnapshot
                if error == nil && querySnapshot != nil {
                    for doc in querySnapshot!.documents {
                        self.readImages.append(doc["imageUrl"] as? String ?? "")
                    }
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("QuerySnapshot is empty")
                    return
                }
                DispatchQueue.main.async {
                    self.newEntryLogs = documents.compactMap { document in
                        try? document.data(as: LogBookModel.self)
                    }
                }
            }
    }
    
    func updateLogBookText(){
        //TODO Updatefunktion bzw. edit Button
        
    }
    
    func dateFormatter() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: dateVm.date)
    }
    
    
    func requestLocation(){
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    @MainActor
    func locationManager(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]){
        if let lastLocation = location.last {
            self.lastLocation = lastLocation
            self.mapCameraPosition = MapCameraPosition.camera(MapCamera(centerCoordinate: lastLocation.coordinate, distance: 5000))
            self.latitude = lastLocation.coordinate.latitude
            self.longitude = lastLocation.coordinate.longitude
            print("Deine ausgewählten Koordinaten sind \(self.latitude) und \(self.longitude)")
        }
    }
    
    func removeListener(){
        self.listener = nil
        self.newEntryLogs = []
        self.readImages = []
    }
}








//        FirebaseManager.shared.firestore.collection("newLogEntry").getDocuments { snapshot, error in
//
//            if error == nil && querySnapshot != nil {
//
//                var imagePaths = [String]()
//
//                //Loop for all returned docs
//                for doc in snapshot!.documents {
//                    imagePaths.append(doc["url"] as! String)
//                }
//                //Loop through each file an fetch the data storage
//                for imagePath in imagePaths {
//                    let ref = FirebaseManager.shared.storage.reference()
//                    let fileRef = ref.child(imagePath)
//
//                    //Retrieve the data
//                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
//                        if error == nil && data != nil {
//                            if let image = UIImage(data: data!) {
//                                DispatchQueue.main.async {
//                                    self.readImages.append(image)
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//




//    func uploadPhoto(){
//        guard selectedImage != nil else {
//            return
//        }
//
//        let imageData = selectedImage!.jpegData(compressionQuality: 0.8)
//
//        guard imageData != nil else {
//            return
//        }
//
//        let imagePath = "images\(UUID().uuidString).jpg"
//        let fileRef = FirebaseManager.shared.storage.reference().child(imagePath)
//
//        let uploadTask = fileRef.putData(imageData!, metadata: nil){
//            metadata, error in
//
//            if error == nil && metadata != nil {
//                FirebaseManager.shared.firestore.collection("newLogEntry").document().setData(["imageUrl": imagePath])
//                self.imageUrl = imagePath
//                print("Image uploaded")
//
//
//            }
//        }
//    }
