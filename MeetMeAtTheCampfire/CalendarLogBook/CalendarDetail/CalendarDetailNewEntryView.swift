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
    @AppStorage("isDarkMode") private var isDark: Bool = false
    @AppStorage("entryButton") private var entryButtonIsActive: Bool = true
    @State private var showImagePicker: Bool = false
    @State private var selectedImage: UIImage?
    @State private var showToDoSheet: Bool = false
    @State private var isAnimated: Bool = false
    
    var body: some View {
        NavigationView{
            VStack{
                Divider()
                ZStack{
                    VStack{
                        VStack{
                            ScrollView{
                                VStack{
                                    Text("1. Wähle deinen Standort")
                                        .font(.callout)
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: -6, trailing: 0))
                                    ZStack{
                                        MapKitNewEntryView()
                                            .frame(minWidth: 300,  minHeight: 200)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.cyan, lineWidth: 2)
                                            )
                                        Text("Klicke auf den Pfeil")
                                            .bold()
                                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 170, trailing: 50))
                                    }
                                    .padding(0)
                                    Divider()
                                    //Ab hier Image Picker
                                    Text("2. Wähle ein Galeriefoto")
                                        .font(.callout)
                                        .padding(EdgeInsets(top: 2, leading: 0, bottom: -4, trailing: 0))
                                   
                                    
                                    if calendarDetailItemVm.selectedImage != nil {
                                        VStack{
                                            Image(uiImage: calendarDetailItemVm.selectedImage!)
                                                .resizable()
                                                .scaledToFit()
                                                .padding(0)
                                                .frame(minWidth: 300,  minHeight: 2000)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(Color.cyan, lineWidth: 2)
                                                )
                                            Button{
                                                showImagePicker.toggle()
                                            }label: {
                                                Image(systemName: "photo.tv")
                                                Text("Foto ändern")
                                            }
                                        }
                                    } else {
                                        VStack{
                                            
                                            //Button für Image Picker
                                            Button{
                                                showImagePicker.toggle()
                                            }label: {
                                                Image(systemName: "photo.tv")
                                                Text("Foto hinzufügen oder ändern")
                                            }
                                            .frame(minWidth: 300,  minHeight: 150)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.cyan, lineWidth: 2)
                                            )
                                        }
                                        .padding(0)
                                    }
                                    Divider()
                                    //Ab hier Text für die Erlebnisse
                                    Text("3. Beschreibe deine Erlebnisse")
                                        .font(.callout)
                                        .padding(EdgeInsets(top: 2, leading: 0, bottom: -6, trailing: 0))
                                    TextEditor(text: $calendarDetailItemVm.logBookText)
                                        .font(.system(size: 17).bold())
                                        .textFieldStyle(.roundedBorder)
                                        .autocorrectionDisabled()
                                        .padding(1)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.cyan, lineWidth: 2)
                                        )
                                        .frame(minWidth: 300,  minHeight: 150)
                                }
                                .frame(width: 300, alignment: .center)
                                .padding(5)
                            }
                        }
                        Divider()
                        VStack{
                            //Button zum speichern von Bildern
                            ButtonTextAction(iconName: "square.and.arrow.down", text: "Speichern"){
                                calendarDetailItemVm.createlogBookText(logBookText: calendarDetailItemVm.logBookText)
                                calendarDetailItemVm.logBookText = ""
                                dismiss()
                            }
                        }
                        .padding()
                    }
                    VStack{
                        if entryButtonIsActive {
                            Button{
                                showToDoSheet.toggle()
                            } label: {
                                CalendarInfoButtonView()
                            }
                            .rotationEffect(Angle(degrees: isAnimated ? -0 : 20))
                            .animation(Animation.easeInOut(duration: 0.3).repeatCount(7, autoreverses: true), value: isAnimated)
                        }
                    }
                    .offset(x: 100, y: 150)
                    .onAppear {
                        isAnimated = true
                    }
                }
            }
            .toolbar{
                Button("Abbrechen"){
                    calendarDetailItemVm.stopLocationRequest()
                    dismiss()
                }
            }
            .navigationBarTitle("Neuer Logbuch Eintrag")
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
            .background(
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.2)
                    .ignoresSafeArea(.all))
        }
        .onAppear {
            calendarDetailItemVm.requestLocation()
        }
        .onDisappear{
            calendarDetailItemVm.removeListener()
            isAnimated = false
        }
        .sheet(isPresented: $showImagePicker, onDismiss: nil) {
            ImagePicker(selectedImage: $calendarDetailItemVm.selectedImage, showImagePicker: $showImagePicker)
        }
        .sheet(isPresented: $showToDoSheet, onDismiss: nil) {
            CalendarNewEntrySheetView(showToDoSheet: $showToDoSheet)
                .presentationDetents([.medium])
        }
        .toolbar(.hidden, for: .tabBar)
        .background(Color(UIColor.systemBackground))
    }
}

#Preview{
    CalendarDetailNewEntryView(calendarDetailItemVm: CalendarDetailItemViewModel(calendarItemModel: LogBookModel(userId: "", formattedDate: "", logBookText: "", latitude: 0.0, longitude: 0.0, imageUrl: "", containsLogBookEntry: false), date: Date()))
}
