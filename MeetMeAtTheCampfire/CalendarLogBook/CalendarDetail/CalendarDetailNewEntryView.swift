//
//  CalendarDetailNewEntryView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 22.03.24.
//

import SwiftUI
import MapKit

struct CalendarDetailNewEntryView: View {
    @ObservedObject var calendarDetailItemVm: CalendarDetailItemViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State var showImagePicker: Bool = false
    @State var selectedImage: UIImage?
    
    var body: some View {
        NavigationStack{
            VStack{
                ScrollView{
                    VStack{
                        Text("1. Wähle Deinen aktuellen Standort")
                            .font(.callout)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: -6, trailing: 0))
                        ZStack{
                            MapKitNewEntryView()
                            Text("Klicke den Pfeil auf der Karte")
                                .bold()
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 250, trailing: 50))
                            
                        }
                        .padding(0)
                        Text("2. Schreibe hier Deine Erlebnisse rein")
                            .font(.callout)
                            .padding(EdgeInsets(top: 2, leading: 0, bottom: -6, trailing: 0))
                        TextEditor(text: $calendarDetailItemVm.logBookText)
                            .fontDesign(.rounded)
                            .padding(1)
                            .frame(minWidth: 300,  minHeight: 100)
                            .border(Color.blue, width: 2)
                        //Ab hier Image Picker
                        Text("3. Wähle auf Wunsch ein Galeriefoto   ")
                            .font(.callout)
                            .padding(EdgeInsets(top: 2, leading: 0, bottom: -4, trailing: 0))
                        if selectedImage != nil {
                            Image(uiImage: selectedImage!)
                                .resizable()
                                .scaledToFit()
                                .padding(0)
                        }
                        //Button für Image Picker
                        Button{
                            showImagePicker.toggle()
                        }label: {
                            Image(systemName: "photo.tv")
                            Text("Foto hinzufügen oder ändern")
                        }
                    }
                    .frame(width: 300, alignment: .center)
                    .padding(5)
                }
                ButtonTextAction(iconName: "square.and.arrow.down", text: "Speichern"){
                    calendarDetailItemVm.createlogBookText(logBookText: calendarDetailItemVm.logBookText)
    //Button zum speichern von Bildern
                    uploadPhoto()
                    
                    
                    dismiss()
                }
            }
            .scrollContentBackground(.hidden)
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
                    .ignoresSafeArea())
            .toolbar{
                Button("abbrechen"){
                    dismiss()
                }
            }
            .navigationTitle("Neuer Logbuch Eintrag")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            calendarDetailItemVm.requestLocation()
        }
        .sheet(isPresented: $showImagePicker, onDismiss: nil) {
            ImagePicker(selectedImage: $selectedImage, showImagePicker: $showImagePicker)
        }
    }
    
    func uploadPhoto(){
        guard selectedImage != nil else {
            return
        }
        
        let imageData = selectedImage!.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            return
        }
        
        let fileRef = FirebaseManager.shared.storage.reference().child("images\(UUID().uuidString).jpg")
        
        let uploadTask = fileRef.putData(imageData!, metadata: nil){
            metadata, error in
            
            if error == nil && metadata != nil {
                
            }
        }
    }
    
}

#Preview {
    CalendarDetailNewEntryView(calendarDetailItemVm: CalendarDetailItemViewModel(calendarItemModel: LogBookModel(userId: "1", formattedDate: "", logBookText: "Hallo", laditude: 0.0, longitude: 0.0), calendarVm: CalendarViewModel(date: Date())))
}
