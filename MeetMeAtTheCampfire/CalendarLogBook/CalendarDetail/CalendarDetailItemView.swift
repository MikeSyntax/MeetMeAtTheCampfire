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
    @State private var showAnimation: Bool = false
    
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
                                AsyncImage(
                                    url: URL(string: image),
                                    content: { image in
                                        image
                                            .resizable()
                                            .frame(maxWidth: 300, maxHeight: 300)
                                            .cornerRadius(10)
                                            .shadow(radius: 10)
                                    },
                                    placeholder: {
                                        Image(systemName: "photo")
                                            .resizable()
                                            .frame(maxWidth: 300, minHeight: 300)
                                            .cornerRadius(10)
                                            .shadow(radius: 10)
                                    }
                                )
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
                    .transition(.move(edge: .bottom))
                    .animation(.default, value: showAnimation)
                }
            }
            .onAppear {
                calendarDetailItemVm.readLogBookText(formattedDate: calendarDetailItemVm.formattedDate)
                showAnimation = true
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
    }
}




