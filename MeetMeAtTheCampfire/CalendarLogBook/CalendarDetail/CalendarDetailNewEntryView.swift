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
    //@ObservedObject var mapKitVm: MapKitViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    MapKitNewEntryView()
                    Spacer()
                    TextField("Gib hier deine Erlebnisse ein", text: $calendarDetailItemVm.logBookText)
                        .textFieldStyle(.roundedBorder)
                        .padding()
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
    }
}
