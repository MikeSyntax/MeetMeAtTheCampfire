//
//  CalendarDetailItemView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 20.03.24.
//

//import SwiftUI
//import MapKit
//
//struct CalendarDetailItemView: View {
//    @ObservedObject var calendarDetailItemVm: CalendarDetailItemViewModel
//
//    @State private var showNewEntryView: Bool = false
//    @State private var logBookEntryIsEmpty: Bool = false
//    @State private var annotation = Annotation(title: "Hier war ich", coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))
//
//    var body: some View {
//        NavigationStack{
//            VStack {
//                Divider()
//                HStack{
//                    Text("Meine Erlebnisse vom")
//                    Text(calendarDetailItemVm.formattedDate)
//                }
//                .underline()
//                .foregroundColor(.gray)
//                .font(.callout)
//                .bold()
//                .italic()
//                .padding(20)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.gray, lineWidth: 2)
//                )
//                .frame(width: 298)
//                ScrollView {
//                    VStack{
//                        ZStack {
//                            Map(coordinateRegion: .constant(MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))), showsUserLocation: true, annotationItems: [annotation]) { annotation in
//                                MapPin(coordinate: annotation.coordinate, tint: .red)
//                            }
//                            .edgesIgnoringSafeArea(.all)
//                        }
//                        .frame(width: 300, height: 200)
//                        ZStack{
//                            ForEach(calendarDetailItemVm.readImages, id: \.self){ image in
//                                Image(uiImage: image)
//                                    .resizable()
//                                    .cornerRadius(20)
//                                    .shadow(radius: 10)
//                            }
//                        }
//                        .frame(width: 300, height: 300)
//                        ZStack{
//                            ForEach(calendarDetailItemVm.newEntryLogs) {
//                                newEntryLog in
//                                VStack{
//                                    Text(newEntryLog.logBookText)
//                                        .font(.callout)
//                                        .italic()
//                                        .bold()
//                                }
//                            }
//                        }
//                        .frame(width: 300)
//                    }
//                }
//                //Button displayed only wiht empty Logs
//                if calendarDetailItemVm.newEntryLogs.isEmpty || calendarDetailItemVm.newEntryLogs.contains(where: { $0.logBookText.isEmpty && $0.formattedDate == calendarDetailItemVm.formattedDate }){
//                    ButtonTextAction(iconName: "plus", text: "Neuer Eintrag") {
//                        showNewEntryView.toggle()
//                    }
//                    .padding()
//                    .transition(.move(edge: .bottom))
//                    .animation(.default)
//                }
//            }
//            .navigationTitle("Mein Logbuch")
//            // .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                Button {
//                    calendarDetailItemVm.updateLogBookText()
//                } label: {
//                    Text("Edit")
//                    Image(systemName: "pencil")
//                        .font(.caption)
//                        .bold()
//                }
//            }
//            .scrollContentBackground(.hidden)
//            .background(
//                Image("background")
//                    .resizable()
//                    .scaledToFill()
//                    .opacity(0.2)
//                    .ignoresSafeArea())
//        }
//        .onAppear {
//            calendarDetailItemVm.readLogBookText(formattedDate: calendarDetailItemVm.formattedDate)
//        }
//        .onDisappear {
//            calendarDetailItemVm.removeListener()
//        }
//        .sheet(isPresented: $showNewEntryView) {
//            CalendarDetailNewEntryView(calendarDetailItemVm: calendarDetailItemVm)
//        }
//    }
//}
//
//class Annotation: NSObject, Identifiable, MKAnnotation {
//    var id = UUID()
//    var title: String?
//    var coordinate: CLLocationCoordinate2D
//
//    init(title: String?, coordinate: CLLocationCoordinate2D) {
//        self.title = title
//        self.coordinate = coordinate
//    }
//}
//
//#Preview {
//    CalendarDetailItemView(calendarDetailItemVm: CalendarDetailItemViewModel(calendarItemModel: LogBookModel(userId: "1", formattedDate: "date", logBookText: "", laditude: 0.0, longitude: 0.0, imageUrl: ""), calendarVm: CalendarViewModel(date: Date())))
//}
//
//
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
                Spacer()
                VStack{
                    Text("Meine Erlebnisse vom \(calendarDetailItemVm.formattedDate)")
                        .frame(width: 300)
                        .underline()
                        .foregroundColor(.black)
                        .font(.callout)
                        .bold()
                        .italic()
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                }
                Spacer()
                ScrollView {
                    VStack {
                        VStack{
                            MapKitView(calendarDetailItemVm: calendarDetailItemVm)
                                .frame(width: 300, height: 200)
                                .cornerRadius(10)
                        }
                        Spacer()
                        VStack{
                            ForEach(calendarDetailItemVm.readImages, id: \.self){ image in
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(maxWidth: 300, maxHeight: 300)
                                        .cornerRadius(10)
                                        .shadow(radius: 10)
                            }
                        }
                        Spacer()
                        VStack{
                            ForEach(calendarDetailItemVm.newEntryLogs) {
                                newEntryLog in
                                VStack{
                                    Text(newEntryLog.logBookText)
                                        .font(.callout)
                                        .italic()
                                        .bold()
                                        .frame(width: 300)
                                }
                            }
                        }
                    }
                }
                //Button displayed only wiht empty Logs
                if calendarDetailItemVm.newEntryLogs.isEmpty || calendarDetailItemVm.newEntryLogs.contains(where: { $0.logBookText.isEmpty && $0.formattedDate == calendarDetailItemVm.formattedDate }){
                    ButtonTextAction(iconName: "plus", text: "Neuer Eintrag") {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showNewEntryView.toggle()
                        }
                    }
                    .padding()
//                    .transition(.move(edge: .bottom))
//                    .animation(.default)
                }
            }
            .onAppear {
                calendarDetailItemVm.readLogBookText(formattedDate: calendarDetailItemVm.formattedDate)
            }
            .onDisappear {
                calendarDetailItemVm.removeListener()
                calendarDetailItemVm.readImages = []
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
            .scrollContentBackground(.hidden)
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
                    .ignoresSafeArea(.all)
            )
            .navigationTitle("Mein Logbuch")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        .sheet(isPresented: $showNewEntryView) {
            CalendarDetailNewEntryView(calendarDetailItemVm: calendarDetailItemVm)
        }
        .toolbar(.hidden, for: .tabBar)
        .transition(.move(edge: .bottom))
        .animation(.default)
    }
}
