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
                                .border(Color.blue, width: 2)
                                .frame(width: 300, height: 200)
                            Text("Klicke den Pfeil auf der Karte")
                                .bold()
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 170, trailing: 50))
                            
                        }
                        .padding(0)
                        Divider()
                        //Ab hier Image Picker
                        Text("2. Wähle auf Wunsch ein Galeriefoto   ")
                            .font(.callout)
                            .padding(EdgeInsets(top: 2, leading: 0, bottom: -4, trailing: 0))
                        if calendarDetailItemVm.selectedImage != nil {
                            Image(uiImage: calendarDetailItemVm.selectedImage!)
                                .resizable()
                                .scaledToFit()
                                .padding(0)
                                .border(Color.blue, width: 2)
                        }
                        //Button für Image Picker
                        Button{
                            showImagePicker.toggle()
                        }label: {
                            Image(systemName: "photo.tv")
                            Text("Foto hinzufügen oder ändern")
                        }
                        .padding(0)
                        Divider()
                        //Ab hier Text für die Erlebnisse
                        Text("3. Schreibe hier Deine Erlebnisse rein")
                            .font(.callout)
                            .padding(EdgeInsets(top: 2, leading: 0, bottom: -6, trailing: 0))
                        TextEditor(text: $calendarDetailItemVm.logBookText)
                            .fontDesign(.rounded)
                            .padding(1)
                            .frame(minWidth: 300,  minHeight: 200)
                            .border(Color.blue, width: 2)
                        
                    }
                    .frame(width: 300, alignment: .center)
                    .padding(5)
                }
                //Button zum speichern von Bildern
                ButtonTextAction(iconName: "square.and.arrow.down", text: "Speichern"){
                    calendarDetailItemVm.createlogBookText(logBookText: calendarDetailItemVm.logBookText)
                   // calendarDetailItemVm.logBookText = ""
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
            .navigationTitle("Neuer Logbuch Eintrag")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                Button("abbrechen"){
                    dismiss()
                }
            }
        }
        .onAppear {
            calendarDetailItemVm.requestLocation()
        }
        .sheet(isPresented: $showImagePicker, onDismiss: nil) {
            ImagePicker(selectedImage: $calendarDetailItemVm.selectedImage, showImagePicker: $showImagePicker)
        }
    }
    
   
}

#Preview {
    CalendarDetailNewEntryView(calendarDetailItemVm: CalendarDetailItemViewModel(calendarItemModel: LogBookModel(userId: "1", formattedDate: "", logBookText: "Hallo", latitude: 0.0, longitude: 0.0, imageUrl: "", containsLogBookEntry: false), dateVm: CalendarViewModel(date: Date())))
}
