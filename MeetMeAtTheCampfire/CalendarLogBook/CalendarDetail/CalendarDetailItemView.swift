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
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack{
            VStack {
                Divider()
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
                        VStack{
                            ForEach(calendarDetailItemVm.readImages, id: \.self){ image in
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
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(10)
                                            .shadow(radius: 10)
                                    }
                                )
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
                Divider()
                if calendarDetailItemVm.newEntryLogs.isEmpty || calendarDetailItemVm.newEntryLogs.contains(where: { $0.logBookText.isEmpty && $0.formattedDate == calendarDetailItemVm.formattedDate }){
                    ButtonTextAction(iconName: "plus", text: "Neuer Eintrag") {
                        showNewEntryView.toggle()
                    }
                    .padding()
                }
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
            .toolbar{ ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading){
                Button("Zurück") {
                    dismiss()}}
            }
        }
        .onAppear {
            calendarDetailItemVm.readLogBookText(formattedDate: calendarDetailItemVm.formattedDate)
        }
        .onDisappear {
            calendarDetailItemVm.removeListener()
        }
        .sheet(isPresented: $showNewEntryView) {
            CalendarDetailNewEntryView(calendarDetailItemVm: calendarDetailItemVm)
        }
        .toolbar(.hidden, for: .tabBar)
    }
}
#Preview{
    let logbookMod: LogBookModel = LogBookModel(userId: "1", formattedDate: "", logBookText: "Hallo", latitude: 0.0, longitude: 0.0, imageUrl: "", containsLogBookEntry: false)
    
    return CalendarDetailItemView(calendarDetailItemVm: CalendarDetailItemViewModel(calendarItemModel: logbookMod, date: Date()))
}
































// @EnvironmentObject var infoButtonSettings: InfoButtonSettings

//Alles in der HomeView
//
//
//
//@Environment(\.colorScheme) private var colorScheme
//@State private var isDark: Bool
//
//
//
//
//init() {
//        _isDark = State(initialValue: UserDefaults.standard.bool(forKey: "isDarkMode"))
//    }
//
//
//
//
//.preferredColorScheme(isDark ? .dark : .light)
//
//
//
//Button("Toggle Dark Mode") {
//    isDark.toggle()
//    UserDefaults.standard.set(isDark, forKey: "isDarkMode")
//}


































// @EnvironmentObject var infoButtonSettings: InfoButtonSettings

//Alles in der HomeView
//
//
//
//@Environment(\.colorScheme) private var colorScheme
//@State private var isDark: Bool
//
//
//
//
//init() {
//        _isDark = State(initialValue: UserDefaults.standard.bool(forKey: "isDarkMode"))
//    }
//
//
//
//
//.preferredColorScheme(isDark ? .dark : .light)
//
//
//
//Button("Toggle Dark Mode") {
//    isDark.toggle()
//    UserDefaults.standard.set(isDark, forKey: "isDarkMode")
//}
