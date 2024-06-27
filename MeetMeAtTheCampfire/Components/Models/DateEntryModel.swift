//
//  DateEntryModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 27.06.24.
//

//import SwiftUI
//import FirebaseFirestore
//
//struct DateEntryModel: Identifiable, Codable {
//    @DocumentID var id: String?
//    
//    let date: Date
//    let formattedDate: String
//    let isNotEmpty: Bool
//    let userId: String
//
//}
//
//final class CalendarDateShowIcon: ObservableObject {
//    
//    static var shared = CalendarDateShowIcon(isNotEmpty: false, formattedDate: "", userId: "", date: Date())
//    
//    @Published var date: Date
//    @Published var isNotEmpty: Bool
//    @Published var formattedDate: String
//    @Published var userId: String
//    @Published var dateList: [DateEntryModel] = []
//    
//    private var listener: ListenerRegistration? = nil
//    
//    private init(isNotEmpty: Bool, formattedDate: String, userId: String, date: Date) {
//        
//        self.isNotEmpty = isNotEmpty
//        self.formattedDate = formattedDate
//        self.userId = userId
//        self.date = date
//    }
//    
//    
//    func addEntryToCalendarDate(formattedDate: String, isNotEmpty: Bool, date: Date) {
//        guard let userId = FirebaseManager.shared.userId else {
//            return
//        }
//        
//        let insertItem = DateEntryModel(
//            date: date, formattedDate: formattedDate,
//            isNotEmpty: isNotEmpty,
//            userId: userId)
//        
//        do {
//            try FirebaseManager.shared.firestore
//                .collection("dateEntry")
//                .addDocument(from: insertItem)
//            print("Creating icon for dateEntry succesful")
//        } catch {
//            print("Error creating icon for dateEntry: \(error)")
//        }
//    }
//    
//    func readEntriesFromCalendarDate(date: Date) {
//        guard let userId = FirebaseManager.shared.userId else {
//            return
//        }
//        
//        self.listener = FirebaseManager.shared.firestore
//            .collection("dateEntry")
//            .whereField("userId", isEqualTo: userId)
//            .whereField("date", isEqualTo: date)
//            .addSnapshotListener { querySnapshot, error in
//                if let error = error {
//                    print("Error reading dateEntry: \(error.localizedDescription)")
//                    return
//                }
//                
//                guard let documents = querySnapshot?.documents else {
//                    print("No querySnapshot found in dateEntry")
//                    return
//                }
//                DispatchQueue.main.async {
//                    self.dateList = documents.compactMap { document in
//                        try? document.data( as: DateEntryModel.self)
//                    }
//                }
//                
//                if error == nil && querySnapshot != nil {
//                    if let isNotEmpty = self.dateList.first?.isNotEmpty {
//                        self.isNotEmpty = isNotEmpty
//                        print("is not empty \(isNotEmpty)")
//                    }
//                }
//            }
//    }
//    
//    func deleteEntryFromCalendarDate() {
//        
//        
//    }
//}
