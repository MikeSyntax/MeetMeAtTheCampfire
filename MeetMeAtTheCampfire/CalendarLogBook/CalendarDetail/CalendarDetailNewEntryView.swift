//
//  CalendarDetailNewEntryView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 22.03.24.
//


import SwiftUI

struct CalendarDetailNewEntryView: View {
    @ObservedObject var calendarDetailItemVm: CalendarDetailItemViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State var showImagePicker: Bool = false
    @State var selectedImage: UIImage?
    
    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
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
                    calendarDetailItemVm.logBookText = ""
                    dismiss()
                }
                Spacer()
            }
            .toolbar{
                Button("Abbrechen"){
                    dismiss()
                }
            }
            .navigationBarTitle("Neuer Logbuch Eintrag", displayMode: .inline)
            .scrollContentBackground(.hidden)
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
                    .ignoresSafeArea(.all))
        }
        .onAppear {
            calendarDetailItemVm.requestLocation()
        }
        .sheet(isPresented: $showImagePicker, onDismiss: nil) {
            ImagePicker(selectedImage: $calendarDetailItemVm.selectedImage, showImagePicker: $showImagePicker)
        }
        .toolbar(.hidden, for: .tabBar)
    }
}





//import SwiftUI
//
//struct CalendarDetailNewEntryView: View {
//    @ObservedObject var calendarDetailItemVm: CalendarDetailItemViewModel
//    @Environment(\.dismiss) private var dismiss
//
//    @State private var showImagePicker: Bool = false
//
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 20) {
//                Spacer()
//                ScrollView {
//                    VStack(spacing: 20) {
//                        locationSelectionView()
//                        Divider()
//                        imageSelectionView()
//                        Divider()
//                        experienceTextView()
//                    }
//                    .frame(maxWidth: .infinity)
//                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
//                }
//                ButtonTextAction(iconName: "square.and.arrow.down", text: "Speichern"){
//                    calendarDetailItemVm.createlogBookText(logBookText: calendarDetailItemVm.logBookText)
//                    calendarDetailItemVm.logBookText = ""
//                    dismiss()
//                }
//                Spacer()
//            }
//            .navigationTitle("Neuer Logbuch Eintrag")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Abbrechen") {
//                        dismiss()
//                    }
//                }
//            }
//            .onAppear {
//                calendarDetailItemVm.requestLocation()
//            }
//            .background(
//                Image("background")
//                    .resizable()
//                    .scaledToFill()
//                    .opacity(0.2)
//                    .ignoresSafeArea(.all)
//            )
//            .sheet(isPresented: $showImagePicker) {
//                ImagePicker(selectedImage: $calendarDetailItemVm.selectedImage, showImagePicker: $showImagePicker)
//            }
//            .toolbar(.hidden, for: .tabBar)
//        }
//    }
//
//    private func locationSelectionView() -> some View {
//        VStack(spacing: 0) {
//            Text("1. Wähle Deinen aktuellen Standort")
//                .font(.callout)
//                .padding(.bottom, 6)
//
//            MapKitNewEntryView()
//                .border(Color.blue, width: 2)
//                .frame(width: 300, height: 200)
//
//            Text("Klicke den Pfeil auf der Karte")
//                .bold()
//                .padding(.bottom, 170)
//        }
//    }
//
//    private func imageSelectionView() -> some View {
//        VStack(spacing: 0) {
//            Text("2. Wähle auf Wunsch ein Galeriefoto")
//                .font(.callout)
//                .padding(.bottom, 4)
//
//            if let selectedImage = calendarDetailItemVm.selectedImage {
//                Image(uiImage: selectedImage)
//                    .resizable()
//                    .scaledToFit()
//                    .padding(0)
//                    .border(Color.blue, width: 2)
//            }
//            
//            Button {
//                showImagePicker.toggle()
//            } label: {
//                Label("Foto hinzufügen oder ändern", systemImage: "photo.tv")
//            }
//        }
//    }
//
//    private func experienceTextView() -> some View {
//        VStack(spacing: 0) {
//            Text("3. Schreibe hier Deine Erlebnisse rein")
//                .font(.callout)
//                .padding(.bottom, 6)
//
//            TextEditor(text: $calendarDetailItemVm.logBookText)
//                .fontDesign(.rounded)
//                .padding(1)
//                .frame(minWidth: 300, minHeight: 200)
//                .border(Color.blue, width: 2)
//        }
//    }
//}

