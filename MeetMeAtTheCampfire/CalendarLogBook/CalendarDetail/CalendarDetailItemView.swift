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
    @State private var logBookEntryIsEmpty: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack {
                ScrollView {
                    VStack {
                        Text("Eintrag vom \(calendarDetailItemVm.formattedDate)")
                            .font(.callout)
                        MapKitView(calendarDetailItemVm: calendarDetailItemVm)
                            .frame(width: 300, height: 200)
                            .shadow(radius: 10)
                        Spacer()
                        Divider()
                        VStack{
                            ForEach(calendarDetailItemVm.readImages, id: \.self){ image in
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(maxWidth: 300, maxHeight: 300)
                                    .cornerRadius(20)
                                    .shadow(radius: 10)
                            }
                        }
                        Divider()
                        VStack{
                            ForEach(calendarDetailItemVm.newEntryLogs) {
                                newEntryLog in
                                VStack{
                                    Text(newEntryLog.logBookText)
                                        .font(.callout)
                                        .italic()
                                        .bold()
                                }
                            }
                        }
                        Divider()
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
            .onAppear {
                calendarDetailItemVm.readLogBookText(formattedDate: calendarDetailItemVm.formattedDate)
            }
            .onDisappear {
                calendarDetailItemVm.removeListener()
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

//#Preview {
//    CalendarDetailItemView(calendarDetailItemVm: CalendarDetailItemViewModel(calendarItemModel: LogBookModel(userId: "1", formattedDate: "date", logBookText: "", laditude: 0.0, longitude: 0.0, imageUrl: ""), calendarVm: CalendarViewModel(date: Date())))
//}
