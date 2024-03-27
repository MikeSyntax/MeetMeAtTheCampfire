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
            ScrollView{
                VStack{
                    MapKitNewEntryView()
                    Spacer()
                    TextField("Gib hier deine Erlebnisse ein", text: $calendarDetailItemVm.logBookText)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    Spacer()
                    //Ab hier Image Picker
                    if selectedImage != nil {
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .frame(width: 300, height: 300, alignment: .center)
                    }
                   //Button für Image Picker
                    Button{
                        showImagePicker.toggle()
                    }label: {
                        Text("Foto hinzufügen oder ändern")
                    }
                    //.buttonStyle(.borderedProminent)
                    
                }
                
            }
            ButtonTextAction(iconName: "", text: "Speichern"){
                calendarDetailItemVm.createlogBookText(logBookText: calendarDetailItemVm.logBookText)
                dismiss()
            }
            .toolbar{
                Button("abbrechen"){
                    dismiss()
                }
            }
            .navigationTitle("Neuer Log Eintrag")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            calendarDetailItemVm.requestLocation()
        }
        .sheet(isPresented: $showImagePicker, onDismiss: nil) {
            ImagePicker(selectedImage: $selectedImage, showImagePicker: $showImagePicker)
        }
    }
}
