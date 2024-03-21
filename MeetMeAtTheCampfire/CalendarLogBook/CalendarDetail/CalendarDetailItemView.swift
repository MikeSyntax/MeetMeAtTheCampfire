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
    
//    var user: UserModel
//    
//    init(user: UserModel, calendarDetailItemVm: CalendarDetailItemViewModel){
//        self.user = user
//        self.calendarDetailItemVm = calendarDetailItemVm.self
//    }
    
    var body: some View {
        
//        var userExiting: LogBookModel = LogBookModel(userId: user.id ?? "no user id" , formattedDate: calendarDetailItemVm.formattedDate, logBookText: calendarDetailItemVm.logBookText, laditude: calendarDetailItemVm.latitude, longitude: calendarDetailItemVm.longitude)
        let color = bgColor.randomElement()
        VStack{
            Text("Mein Logbuch")
                .font(.title)
                .bold()
            Text("Eintrag vom \(calendarDetailItemVm.formattedDate)")
                .font(.callout)
                .bold()
            MapKitView(/*mapKitVm: MapKitViewModel(), calenderDetailVm: CalendarDetailItemViewModel(calendarItemModel: userExiting, calendarVm: CalendarViewModel(date: calendarDetailItemVm.calendarVm.date))*/)
            Spacer()
            
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
    }
}


//#Preview {
//    CalendarDetailItemView(user: UserModel(id: "1", email: "", registeredTime: Date(), userName: "Hans", timeStampLastVisitChat: Date()))
//}
