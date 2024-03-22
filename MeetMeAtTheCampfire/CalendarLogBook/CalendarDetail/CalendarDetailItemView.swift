//
//  CalendarDetailItemView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 20.03.24.
//

import SwiftUI
import MapKit

struct CalendarDetailItemView: View {
    @ObservedObject var calendarDetailItemVm: CalendarDetailItemViewModel
    
    @State private var showNewEntryView: Bool = false
    @State private var bgColor: [Color] = [.blue, .green, .yellow, .red, .pink, .brown]
    
    var body: some View {
        let color = bgColor.randomElement()
        
        VStack{
            Text("Mein Logbuch")
                .font(.title)
                .bold()
            Text("Eintrag vom \(calendarDetailItemVm.formattedDate)")
                .font(.callout)
                .bold()
            MapKitView(calendarDetailItemVm: calendarDetailItemVm)
            Spacer()
            
            Text(calendarDetailItemVm.logBookText)
                .font(.callout)
            Spacer()
            if calendarDetailItemVm.logBookText.isEmpty {
                ButtonTextAction(iconName: "plus", text: "Neuer Eintrag"){
                    showNewEntryView.toggle()
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(color)
        .shadow(radius: 10)
        .toolbar{
            Button{
                calendarDetailItemVm.updateLogBookText()
            } label: {
                Text("Edit")
                Image(systemName: "pencil.tip")
                    .font(.caption)
            }
        }
        .sheet(isPresented: $showNewEntryView) {
            CalendarDetailNewEntryView(calendarDetailItemVm: calendarDetailItemVm)
            
        }
    }
}

