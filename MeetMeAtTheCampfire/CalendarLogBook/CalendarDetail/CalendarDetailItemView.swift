//
//  CalendarDetailItemView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 20.03.24.
//

import SwiftUI
import MapKit
import SwiftData

struct CalendarDetailItemView: View {
    
    @ObservedObject var calendarDetailItemVm: CalendarDetailItemViewModel
    @State var showNewEntryView: Bool = false
    @State private var isNewImageLoading: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) private var context
    @Query private var items: [LogBookAtivity]
    
    var body: some View {
        NavigationStack{
            VStack {
                VStack{
                    Text("Meine Erlebnisse vom \(calendarDetailItemVm.formattedDate)")
                        .frame(width: 300)
                        .underline()
                        .font(.callout)
                        .bold()
                        .italic()
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.cyan, lineWidth: 2)
                        )
                }
                .padding(.top)
                Spacer()
                ScrollView {
                    VStack {
                        VStack{
                            MapKitView(calendarDetailItemVm: calendarDetailItemVm)
                                .frame(width: 300,  height: 200)
                                .cornerRadius(10)
                        }
                        VStack{
                            ForEach(calendarDetailItemVm.readImages, id: \.self){ image in
                                ZStack{
                                    if !image.isEmpty {
                                        AsyncImage(
                                            url: URL(string: image),
                                            content: { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .cornerRadius(10)
                                                    .shadow(radius: 10)
                                            },
                                            placeholder: {
                                                if isNewImageLoading {
                                                    ProgressView()
                                                        .progressViewStyle(CircularProgressViewStyle())
                                                        .scaleEffect(3)
                                                        .padding(EdgeInsets(top: 30, leading: 0, bottom: 30, trailing: 0))
                                                }
                                            }
                                        )
                                    }
                                }
                                .onAppear{
                                    isNewImageLoadingSlow()
                                }
                            }
                        }
                        .frame(width: 300)
                        Spacer()
                        VStack{
                            ForEach(calendarDetailItemVm.newEntryLogs) {
                                newEntryLog in
                                Text(newEntryLog.logBookText)
                                    .font(.callout)
                                    .italic()
                                    .bold()
                                    .frame(width: 300)
                            }
                        }
                    }
                }
                if calendarDetailItemVm.newEntryLogs.isEmpty ||
                    calendarDetailItemVm.newEntryLogs.contains(
                        where: { $0.logBookText.isEmpty && $0.formattedDate == calendarDetailItemVm.formattedDate }) &&
                    calendarDetailItemVm.imageUrl.isEmpty {
                    Image(.empty)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .frame(width: 250)
                        .opacity(0.7)
                    Divider()
                    ButtonTextAction(iconName: "plus", text: "Neuer Eintrag") {
                        showNewEntryView.toggle()
                    }
                } else {
                    Divider()
                    ButtonDestructiveTextAction(iconName: "trash", text: "Eintrag löschen"){
                        if !calendarDetailItemVm.logBookText.isEmpty && calendarDetailItemVm.imageUrl.isEmpty {
                            calendarDetailItemVm.deleteLogBookText(formattedDate: calendarDetailItemVm.formattedDate)
                            calendarDetailItemVm.readImages = []
                            calendarDetailItemVm.logBookText = ""
                            deleteItemChoice(date: calendarDetailItemVm.date, items: items)
                            
                        } else {
                            calendarDetailItemVm.deleteLogBookText(formattedDate: calendarDetailItemVm.formattedDate)
                            calendarDetailItemVm.deleteImage(imageUrl: calendarDetailItemVm.newEntryLogs.first?.imageUrl ?? "no image found")
                            calendarDetailItemVm.readImages = []
                            calendarDetailItemVm.logBookText = ""
                            deleteItemChoice(date: calendarDetailItemVm.date, items: items)
                        }
                    }
                }
                Divider()
            }
            .scrollContentBackground(.hidden)
            .background(
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.2)
                    .ignoresSafeArea(.all))
            .navigationBarTitle("Mein Logbuch", displayMode: .inline)
            .navigationBarBackButtonHidden()
            .toolbar{
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading){
                    Button("Zurück"){
                        dismiss()
                    }
                }
                //Button is only shown if not empty
                if !calendarDetailItemVm.newEntryLogs.isEmpty || calendarDetailItemVm.newEntryLogs.contains(where: { !$0.logBookText.isEmpty && $0.formattedDate == calendarDetailItemVm.formattedDate }){
                    ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing){
                        Button("Bearbeiten"){
                            showNewEntryView.toggle()
                        }
                    }
                }
                
            }
        }
        .onAppear {
            calendarDetailItemVm.readLogBookText(formattedDate: calendarDetailItemVm.formattedDate)
        }
        .onDisappear {
            calendarDetailItemVm.removeListener()
        }
        .sheet(isPresented: $showNewEntryView) {
            CalendarDetailNewEntryView(calendarDetailItemVm: calendarDetailItemVm, showNewEntryView: $showNewEntryView)
        }
        .toolbar(.hidden, for: .tabBar)
        .background(Color(UIColor.systemBackground))
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification, object: nil)) { notification in
            print(notification)
        }
    }
    func isNewImageLoadingSlow(){
        isNewImageLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0){
            isNewImageLoading = false
        }
    }
   
    func deleteItemChoice(date: Date, items: [LogBookAtivity]) {
        let targetValue = date
        for (index, item) in items.enumerated() {
            if item.date == targetValue {
                context.delete(item)
                break
            }
        }
    }
}

#Preview{
    let logbookMod: LogBookModel = LogBookModel(userId: "1", formattedDate: "", logBookText: "Hallo", latitude: 0.0, longitude: 0.0, imageUrl: "", containsLogBookEntry: false)
    
    return CalendarDetailItemView(calendarDetailItemVm: CalendarDetailItemViewModel(calendarItemModel: logbookMod, date: Date()))
        .modelContainer(for: LogBookAtivity.self)
}
