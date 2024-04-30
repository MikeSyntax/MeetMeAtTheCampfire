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
    @AppStorage("entryButton") private var entryButtonIsActive: Bool = true
    @State private var showImagePicker: Bool = false
    @State private var selectedImage: UIImage?
    @State private var showToDoSheet: Bool = false
    @State private var isAnimated: Bool = false
    
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                ZStack{
                    VStack{
                        ScrollView{
                            VStack{
                                //Ab hier MapKit
                                VStack{
                                    Text("1. Wähle deinen Standort")
                                        .font(.callout)
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: -6, trailing: 0))
                                    MapKitNewEntryView()
                                        .frame(minWidth: 300,  minHeight: 200)
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.cyan, lineWidth: 2)
                                        )
                                        .ignoresSafeArea()
                                        .padding(0)
                                }
                                Divider()
                                //Ab hier Image Picker
                                VStack{
                                    Text("2. Wähle ein Galeriefoto")
                                        .font(.callout)
                                        .padding(EdgeInsets(top: 2, leading: 0, bottom: -6, trailing: 0))
                                    if calendarDetailItemVm.selectedImage != nil {
                                        VStack{
                                            Image(uiImage: calendarDetailItemVm.selectedImage!)
                                                .resizable()
                                                .scaledToFit()
                                                .cornerRadius(10)
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
                                        .frame(minWidth: 300,  minHeight: 200)
                                    } else {
                                        VStack{
                                            Button{
                                                showImagePicker.toggle()
                                            }label: {
                                                Image(systemName: "photo.tv")
                                                Text("Foto hinzufügen oder ändern")
                                            }
                                        }
                                        .frame(minWidth: 300,  minHeight: 150)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.cyan, lineWidth: 2)
                                        )
                                        .padding(0)
                                    }
                                }
                                Divider()
                                //Ab hier Text für die Erlebnisse
                                VStack{
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
                            }
                            .frame(width: 300, alignment: .center)
                            .padding(15)
                        }
                        VStack{
                            //Button zum speichern von Bildern
                            ButtonTextAction(iconName: "square.and.arrow.down", text: "Speichern"){
                                calendarDetailItemVm.createlogBookText(logBookText: calendarDetailItemVm.logBookText)
                                calendarDetailItemVm.logBookText = ""
                                dismiss()
                            }
                        }
                        
                    }
                    VStack(alignment: .trailing){
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
                    .offset(x: 130, y: 180)
                    .onAppear {
                        isAnimated = true
                    }
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
            .toolbar{
                Button("Abbrechen"){
                    calendarDetailItemVm.stopLocationRequest()
                    dismiss()
                }
            }
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
