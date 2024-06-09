//
//  CalendarDetailItemViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 20.03.24.
//

import FirebaseFirestore
import MapKit
import SwiftUI
import UIKit

final class CalendarDetailItemViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var newEntryLogs: [LogBookModel] = []
    @Published var listForShowButton: [LogBookModel] = []
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
    @Published var isNewImageLoading: Bool = false
    
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
    
    @MainActor
    func createlogBookText(logBookText: String) {
        guard let uploadImage = selectedImage else {
            createLogBookEntry(logBookText: logBookText, imageUrl: nil)
            return
        }
        
        let resizedImage = resizeImage(image: uploadImage, targetSize: CGSize(width: 800, height: 800))
        
        let imageData = resizedImage.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            return
        }
       
        let fileRef = FirebaseManager.shared.storage
            .reference()
            .child("/images/\(UUID().uuidString).jpg")
        
        fileRef.putData(imageData!, metadata: nil) { metadata, error in
            if let error {
                print("Error loading metadata \(error)")
                return
            }
            
            if error == nil && metadata != nil {
                print("Image upload succesfull")
            }
            
            fileRef.downloadURL { url, error in
                guard let imageUrl = url?.absoluteString else {
                    print("bad url request")
                    return
                }
                self.createLogBookEntry(
                    logBookText: logBookText,
                    imageUrl: imageUrl)
            }
        }
    }
    
    //Helped by ChatGPT
    @MainActor
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        // 1. Hole die ursprüngliche Größe des Bildes
        let size = image.size
        // 2. Berechne das Verhältnis der Zielbreite zur Originalbreite
        let widthRatio = targetSize.width / size.width
        // 3. Berechne das Verhältnis der Zielhöhe zur Originalhöhe
        let heightRatio = targetSize.height / size.height
        // 4. Deklariere eine Variable, um die neue Größe zu speichern
        var newSize: CGSize
        // 5. Wenn das Höhenverhältnis kleiner ist als das Breitenverhältnis
        if widthRatio > heightRatio {
            // 6. Berechne die neue Größe, wobei die Höhe maßgeblich ist und die Breite proportional angepasst wird
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            // 7. Berechne die neue Größe, wobei die Breite maßgeblich ist und die Höhe proportional angepasst wird
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        // 8. Erstelle ein Rechteck mit der neuen Größe, beginnend bei (0,0)
        let rect = CGRect(origin: .zero, size: newSize)
        // 9. Beginne einen neuen Bildkontext mit den Optionen, um ein neues Bild zu zeichnen
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        // 10. Zeichne das Bild in das Rechteck (dies skaliert das Bild)
        image.draw(in: rect)
        // 11. Hole das neu gezeichnete und skalierte Bild aus dem aktuellen Bildkontext
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // 12. Beende den Bildkontext
        UIGraphicsEndImageContext()
        // 13. Gib das neu erstellte Bild zurück
        return newImage!
    }
    
    private func createLogBookEntry(logBookText: String, imageUrl: String?) {
        guard let userId = FirebaseManager.shared.userId else {
            return
        }
        
        let newText = LogBookModel(
            userId: userId,
            formattedDate: self.formattedDate,
            logBookText: logBookText,
            latitude: self.latitude,
            longitude: self.longitude,
            imageUrl: imageUrl ?? "",
            containsLogBookEntry: true
        )
        
        do {
            try FirebaseManager.shared.firestore
                .collection("newLogEntry")
                .addDocument(from: newText)
            
            print("Creating newLogEntry successful")
        } catch {
            print("Error creating newLogEntry: \(error)")
        }
    }
    
    //Read all Data from Firebase
    @MainActor
    func readLogBookText(formattedDate: String){
        guard let userId = FirebaseManager.shared.userId else {
            return
        }
        //SnapshotListener
        self.listener = FirebaseManager.shared.firestore
            .collection("newLogEntry")
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
                    if let imageUrl = self.newEntryLogs.first?.imageUrl {
                        self.imageUrl = imageUrl
                    }
                    if let logBookText = self.newEntryLogs.first?.logBookText {
                        self .logBookText = logBookText
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
                            print("deleting newLogEntry for day \(formattedDate) succesful")
                        }
                    }
                }
            }
    }
    
    func deleteImage(imageUrl: String){
        let imageRef = FirebaseManager.shared.storage
            .reference(forURL: imageUrl)
        
        imageRef.delete() { error in
            if let error = error {
                print("delete imageRef for day \(self.formattedDate) failed: \(error)")
            } else {
                print("delete imageRef for day \(self.formattedDate) successful")
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
            self.mapCameraPosition = MapCameraPosition.camera(
                MapCamera(
                    centerCoordinate: lastLocation.coordinate, distance: 5000))
            self.latitude = lastLocation.coordinate.latitude
            self.longitude = lastLocation.coordinate.longitude
            print("coordinates choosen \(self.latitude) and \(self.longitude)")
        }
    }
    
    func isNewImageLoadingSlow(){
        self.isNewImageLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 100.0){
            self.isNewImageLoading = false
        }
    }
    
    func removeListener(){
        self.listener = nil
        self.newEntryLogs = []
        self.readImages = []
    }
}



//
//
//final class CalendarDetailItemViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
//  
//    @Published var newEntryLogs: [LogBookModel] = []
//    @Published var listForShowButton: [LogBookModel] = []
//    @Published var mapCameraPosition: MapCameraPosition = MapCameraPosition.automatic
//    @Published var lastLocation: CLLocation?
//    @Published var latitude: Double
//    @Published var longitude: Double
//    @Published var logBookText: String = ""
//    @Published var formattedDate: String = ""
//    @Published var userId: String = ""
//    @Published var imageUrl: String = ""
//    @Published var selectedImage: UIImage?
//    @Published var readImages: [String] = []
//    @Published var containsLogBookEntry: Bool = false
//    @Published var isNewImageLoading: Bool = false
//    
//    private var listener: ListenerRegistration? = nil
//    let calendarItemModel: LogBookModel
//    let date: Date
//    
//    private let locationManager = CLLocationManager()
//    
//    init(calendarItemModel: LogBookModel, date: Date) {
//        
//        self.calendarItemModel = calendarItemModel
//        self.latitude = calendarItemModel.latitude
//        self.longitude = calendarItemModel.longitude
//        self.logBookText = calendarItemModel.logBookText
//        self.formattedDate = calendarItemModel.formattedDate
//        self.date = date
//        self.imageUrl = calendarItemModel.imageUrl
//        self.containsLogBookEntry = calendarItemModel.containsLogBookEntry
//        
//        super.init()
//        locationManager.delegate = self
//        
//        self.userId = userId.self
//        formattedDate = dateFormatter()
//    }
//    
//    @MainActor
//    func createlogBookText(logBookText: String) {
//        guard let uploadImage = selectedImage else {
//            createLogBookEntry(logBookText: logBookText, imageUrl: nil)
//            return
//        }
//        
//        let resizedImage = resizeImage(image: uploadImage, targetSize: CGSize(width: 800, height: 800))
//        
//        let imageData = resizedImage.jpegData(compressionQuality: 0.8)
//        
//        guard imageData != nil else {
//            return
//        }
//        
//        let fileRef = FirebaseManager.shared.storage
//            .reference()
//            .child("/images/\(UUID().uuidString).jpg")
//        
//        fileRef.putData(imageData!, metadata: nil) { metadata, error in
//            if let error {
//                print("Error loading metadata \(error)")
//                return
//            }
//            
//            if error == nil && metadata != nil {
//                print("Image upload succesfull")
//            }
//            
//            fileRef.downloadURL { url, error in
//                guard let imageUrl = url?.absoluteString else {
//                    print("bad url request")
//                    return
//                }
//                self.createLogBookEntry(
//                    logBookText: logBookText,
//                    imageUrl: imageUrl)
//            }
//        }
//    }
//    
//    //Helped by ChatGPT
//    @MainActor
//    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
//        // 1. Hole die ursprüngliche Größe des Bildes
//        let size = image.size
//        // 2. Berechne das Verhältnis der Zielbreite zur Originalbreite
//        let widthRatio = targetSize.width / size.width
//        // 3. Berechne das Verhältnis der Zielhöhe zur Originalhöhe
//        let heightRatio = targetSize.height / size.height
//        // 4. Deklariere eine Variable, um die neue Größe zu speichern
//        var newSize: CGSize
//        // 5. Wenn das Höhenverhältnis kleiner ist als das Breitenverhältnis
//        if widthRatio > heightRatio {
//            // 6. Berechne die neue Größe, wobei die Höhe maßgeblich ist und die Breite proportional angepasst wird
//            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
//        } else {
//            // 7. Berechne die neue Größe, wobei die Breite maßgeblich ist und die Höhe proportional angepasst wird
//            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
//        }
//        // 8. Erstelle ein Rechteck mit der neuen Größe, beginnend bei (0,0)
//        let rect = CGRect(origin: .zero, size: newSize)
//        // 9. Beginne einen neuen Bildkontext mit den Optionen, um ein neues Bild zu zeichnen
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
//        // 10. Zeichne das Bild in das Rechteck (dies skaliert das Bild)
//        image.draw(in: rect)
//        // 11. Hole das neu gezeichnete und skalierte Bild aus dem aktuellen Bildkontext
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        // 12. Beende den Bildkontext
//        UIGraphicsEndImageContext()
//        // 13. Gib das neu erstellte Bild zurück
//        return newImage!
//    }
//    
//    private func createLogBookEntry(logBookText: String, imageUrl: String?) {
//        guard let userId = FirebaseManager.shared.userId else {
//            return
//        }
//        
//        let newText = LogBookModel(
//            userId: userId,
//            formattedDate: self.formattedDate,
//            logBookText: logBookText,
//            latitude: self.latitude,
//            longitude: self.longitude,
//            imageUrl: imageUrl ?? "",
//            containsLogBookEntry: true
//        )
//        
//        do {
//            try FirebaseManager.shared.firestore
//                .collection("newLogEntry")
//                .addDocument(from: newText)
//            
//            print("Creating newLogEntry successful")
//        } catch {
//            print("Error creating newLogEntry: \(error)")
//        }
//    }
//    
//    //Read all Data from Firebase
//    @MainActor
//    func readLogBookText(formattedDate: String){
//        guard let userId = FirebaseManager.shared.userId else {
//            return
//        }
//        //SnapshotListener
//        self.listener = FirebaseManager.shared.firestore
//            .collection("newLogEntry")
//            .whereField("userId", isEqualTo: userId)
//            .whereField("formattedDate", isEqualTo: formattedDate)
//            .addSnapshotListener {
//                querySnapshot, error in
//                if let error {
//                    print("Error reading newLogEntrys \(error)")
//                    return
//                }
//                //Load all images in querySnapshot
//                if error == nil && querySnapshot != nil {
//                    for doc in querySnapshot!.documents {
//                        self.readImages.append(doc["imageUrl"] as? String ?? "")
//                    }
//                }
//                
//                guard let documents = querySnapshot?.documents else {
//                    print("QuerySnapshot is empty")
//                    return
//                }
//                DispatchQueue.main.async {
//                    self.newEntryLogs = documents.compactMap { document in
//                        try? document.data(as: LogBookModel.self)
//                    }
//                    if let longitude = self.newEntryLogs.first?.longitude {
//                        self.longitude = longitude
//                    }
//                    if let latitude = self.newEntryLogs.first?.latitude {
//                        self.latitude = latitude
//                    }
//                    if let imageUrl = self.newEntryLogs.first?.imageUrl {
//                        self.imageUrl = imageUrl
//                    }
//                    if let logBookText = self.newEntryLogs.first?.logBookText {
//                        self .logBookText = logBookText
//                    }
//                }
//            }
//    }
//    
//    //Löschen eines Logbuch Eintrags
//    @MainActor
//    func deleteLogBookText(formattedDate: String){
//        guard let userId = FirebaseManager.shared.userId else {
//            return
//        }
//        
//        let ref = FirebaseManager.shared.firestore.collection("newLogEntry")
//        
//        ref.whereField("userId", isEqualTo: userId)
//            .whereField("formattedDate", isEqualTo: formattedDate)
//            .getDocuments() { snapshot, error in
//                if let error = error {
//                    print("error getting newLogEntry document \(error)")
//                    return
//                }
//                
//                for document in snapshot!.documents {
//                    ref.document(document.documentID).delete() { error in
//                        if let error = error {
//                            print("deleting newLogEntry for day \(formattedDate) failed \(error)")
//                        } else {
//                            print("deleting newLogEntry for day \(formattedDate) succesful")
//                        }
//                    }
//                }
//            }
//    }
//    
//    func deleteImage(imageUrl: String){
//        let imageRef = FirebaseManager.shared.storage
//            .reference(forURL: imageUrl)
//        
//        imageRef.delete() { error in
//            if let error = error {
//                print("deleting imageRef for day \(self.formattedDate) failed: \(error)")
//            } else {
//                print("deleting imageRef for day \(self.formattedDate) successful")
//            }
//        }
//    }
//    
//    func dateFormatter() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd.MM.yyyy"
//        return dateFormatter.string(from: self.date)
//    }
//    
//    func stopLocationRequest(){
//        self.locationManager.stopUpdatingLocation()
//    }
//    
//    func requestLocation(){
//        self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.startUpdatingLocation()
//    }
//    
//    @MainActor
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]){
//        
//        if let lastLocation = location.last {
//            self.lastLocation = lastLocation
//            self.mapCameraPosition = MapCameraPosition.camera(
//                MapCamera(
//                    centerCoordinate: lastLocation.coordinate, distance: 5000))
//            self.latitude = lastLocation.coordinate.latitude
//            self.longitude = lastLocation.coordinate.longitude
//            print("coordinates choosen \(self.latitude) and \(self.longitude)")
//        }
//    }
//    
//    func isNewImageLoadingSlow(){
//        self.isNewImageLoading = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 100.0){
//            self.isNewImageLoading = false
//        }
//    }
//    
//    func removeListener(){
//        self.listener = nil
//        self.newEntryLogs = []
//        self.readImages = []
//    }
//}
//
