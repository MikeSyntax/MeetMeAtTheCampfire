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
    @State private var bgColor: [Color] = [.blue, .green, .yellow, .red, .pink, .brown]
    
    var body: some View {
        let color = bgColor.randomElement()
            VStack{
                
                        VStack{
                            Map {
                                Annotation("Mein Standort", coordinate: .init(latitude: calendarDetailItemVm.latitude, longitude: calendarDetailItemVm.longitude)){
                                    Image(systemName: "beach.umbrella")
                                }
                            }
                            .frame(width: 300, height: 300)
                            .padding()
                            Spacer()
                            Text("Mein Logbuch")
                                .font(.title)
                                .bold()
                            Text("Eintrag vom \(calendarDetailItemVm.formattedDate)")
                                .font(.callout)
                                .bold()
                            Text(calendarDetailItemVm.logBookText)
                                .font(.callout)
                            Spacer()
                            if calendarDetailItemVm.logBookText.isEmpty {
                                ButtonTextAction(iconName: "plus", text: "Neuer Eintrag"){
                                    calendarDetailItemVm.createlogBookText()
                                }
                                .padding()
                            }
                        }
                    
                    .background(color)
                    .shadow(radius: 10)
            }
            
            .toolbar{
                Button{
                    calendarDetailItemVm.updateLogBookText()
                } label: {
                    Text("Edit")
                    Image(systemName: "pencil.tip")
                        .font(.caption)
                }
            }
    }
}

#Preview {
    CalendarDetailItemView(calendarDetailItemVm: CalendarDetailItemViewModel(calendarItemModel: LogBookModel(userId: "1", formattedDate: "0", logBookText: "Heute war ich angeln", laditude: 0.0, longitude: 0.0), calendarVm: CalendarViewModel(date: Date())))
}
