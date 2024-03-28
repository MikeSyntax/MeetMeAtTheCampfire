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
    
    var body: some View {
        NavigationStack{
            VStack {
                ScrollView {
                    VStack {
                        Text("Eintrag vom \(calendarDetailItemVm.formattedDate)")
                            .font(.callout)
                        MapKitView(calendarDetailItemVm: calendarDetailItemVm)
                            .frame(width: 300, height: 300)
                        Spacer()
                        Text(calendarDetailItemVm.logBookText)
                            .font(.callout)
                        Spacer()
                    }
                    .padding(5)
                }
                if calendarDetailItemVm.logBookText.isEmpty {
                    ButtonTextAction(iconName: "plus", text: "Neuer Eintrag") {
                        showNewEntryView.toggle()
                    }
                    .padding()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        calendarDetailItemVm.updateLogBookText()
                    } label: {
                        Text("Edit")
                        Image(systemName: "pencil")
                            .font(.caption)
                            .bold()
                    }
                }
            }
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
                    .ignoresSafeArea()
            )
            .navigationTitle("Mein Logbuch")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showNewEntryView) {
            CalendarDetailNewEntryView(calendarDetailItemVm: calendarDetailItemVm)
        }
    }
}

#Preview {
    CalendarDetailItemView(calendarDetailItemVm: CalendarDetailItemViewModel(calendarItemModel: LogBookModel(userId: "1", formattedDate: "", logBookText: "", laditude: 0.0, longitude: 0.0), calendarVm: CalendarViewModel(date: Date())))
}
