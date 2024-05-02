//
//  CalendarDetailItemViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 20.03.24.
//

import FirebaseFirestore
import MapKit
import SwiftUI

class CalendarDetailItemViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    //Leeres Array mit LogBockModels
    @Published var newEntryLogs: [LogBookModel] = []
    //Leeres Arry für den showInfoButton
    @Published var listForShowButton: [LogBookModel] = []
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
    
    @Published var dayIsEmpty: Bool = false
    
    //Listener
    private var listener: ListenerRegistration? = nil
    let calendarItemModel: LogBookModel
    let date: Date
    
    private let locationManager = CLLocationManager()
    
    init(calendarItemModel: LogBookModel, date: Date) {
        
        self.calendarItemModel = calendarItemModel
        self.latitude = calendarItemModel.latitude
        self.longitude = calendarItemModel.longitude
        self.logBookText = calendarItemModel.logBookText
        self.formattedDate = calendarItemModel.formattedDate
        self.date = date
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
                    print("bad url request")
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
                    if let longitude = self.newEntryLogs.first?.longitude {
                        self.longitude = longitude
                    }
                    if let latitude = self.newEntryLogs.first?.latitude {
                        self.latitude = latitude
                    }
                    if let logBookText = self.newEntryLogs.first?.logBookText {
                        self.logBookText = logBookText
                    }
                    if let imageUrl = self.newEntryLogs.first?.imageUrl {
                        self.imageUrl = imageUrl
                    }
                }
            }
    }
    
    //Löschen eines Logbuch Eintrags
    @MainActor
    func deleteLogBookText(formattedDate: String){
        guard let userId = FirebaseManager.shared.userId else {
            return
        }
        
        let ref = FirebaseManager.shared.firestore.collection("newLogEntry")
        
        ref.whereField("userId", isEqualTo: userId)
            .whereField("formattedDate", isEqualTo: formattedDate)
            .getDocuments() { snapshot, error in
                if let error = error {
                    print("error getting newLogEntry document \(error)")
                    return
                }
                
                for document in snapshot!.documents {
                    ref.document(document.documentID).delete() { error in
                        if let error = error {
                            print("deleting newLogEntry for day \(formattedDate) failed \(error)")
                        } else {
                            print("deleting newLogEntry for day \(formattedDate) succesfull")
                        }
                    }
                }
            }
    }
    
    @MainActor
    func deleteImage(imageUrl: String){
        let imageRef = FirebaseManager.shared.storage.reference(forURL: imageUrl)
        
        imageRef.delete { error in
            if let error = error {
                print("delete imageRef failed: \(error)")
            } else {
                print("delete imageRef successful")
            }
        }
    }
    
    
    func dateFormatter() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: self.date)
    }
    
    func stopLocationRequest(){
        self.locationManager.stopUpdatingLocation()
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
            print("coordinates choosen \(self.latitude) and \(self.longitude)")
        }
    }
    
    func removeListener(){
        self.listener = nil
        self.newEntryLogs = []
        self.readImages = []
    }
}
