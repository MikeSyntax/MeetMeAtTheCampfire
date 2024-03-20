//
//  CalenderDetailView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 19.03.24.
//

import SwiftUI
import MapKit

struct CalendarDetailView: View {
    let calendarVm: CalendarViewModel
    
    var body: some View {
        VStack{
            Text("Tag: \(formattedDate)")
                .font(.callout)
            Spacer()
        }
        .toolbar{
            Button{
               //todo Edit Funktion
            } label: {
                Text("Edit")
                Image(systemName: "pencil.tip")
            }
        }
    }
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy" // oder ein anderes gewünschtes Datumsformat
        return dateFormatter.string(from: calendarVm.date)
    }
}

#Preview {
    CalendarDetailView(calendarVm: CalendarViewModel(date: Date()))
}

