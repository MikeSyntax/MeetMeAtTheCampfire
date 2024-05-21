//
//  CalendarDetailNewEntryView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 22.03.24.
//

import SwiftUI
import SwiftData

struct CalendarDetailNewEntryView: View {
    
    @ObservedObject var calendarDetailItemVm: CalendarDetailItemViewModel
    @AppStorage("entryButton") private var entryButtonIsActive: Bool = true
    @AppStorage("notifications") private var notificationsOn: Bool = true
    @State private var showImagePicker: Bool = false
    @State private var selectedImage: UIImage?
    @State private var showToDoSheet: Bool = false
    @State private var showUserChoiceAnnotation: Bool = false
    @State private var isAnimated: Bool = false
    @State private var showSuccessfulUploadAlert = false
    @Binding var showNewEntryView: Bool
    @Environment(\.modelContext) private var context
    @Query private var items: [LogBookAtivity]
    @FocusState var isInputActive: Bool
    
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                ZStack{
                    VStack{
                        ScrollView{
                            VStack{
                                //Ab hier MapKit
                                VStack{
                                    Text("1. Wähle deinen jetzigen Standort")
                                        .font(.callout)
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: -6, trailing: 0))
                                    MapKitNewEntryView()
                                        .frame(
                                            minWidth: 300,
                                            minHeight: 200)
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.cyan, lineWidth: 2)
                                        )
                                        .ignoresSafeArea()
                                        .padding(0)
//                                    Button("oder setze selber einen Pin"){
//                                        showUserChoiceAnnotation.toggle()
//                                    }
                                }
                                Divider()
                                //Ab hier Image Picker
                                VStack{
                                    Text("2. Wähle ein Galeriefoto")
                                        .font(.callout)
                                        .padding(
                                            EdgeInsets(
                                                top: 2,
                                                leading: 0,
                                                bottom: -6,
                                                trailing: 0))
                                    VStack{
                                        if !calendarDetailItemVm.imageUrl.isEmpty {
                                            VStack{
                                                AsyncImage(
                                                    url: URL(string: calendarDetailItemVm.imageUrl),
                                                    content: { image in
                                                        image
                                                            .resizable()
                                                            .scaledToFit()
                                                            .cornerRadius(10)
                                                            .overlay(
                                                                RoundedRectangle(cornerRadius: 10)
                                                                    .stroke(Color.cyan, lineWidth: 2)
                                                            )
                                                    },
                                                    placeholder: {
                                                        Image(systemName: "photo")
                                                            .frame(
                                                                minWidth: 300,
                                                                minHeight: 150)
                                                            .overlay(
                                                                RoundedRectangle(cornerRadius: 10)
                                                                    .stroke(Color.cyan, lineWidth: 2)
                                                            )
                                                    }
                                                )
                                                Button{
                                                    calendarDetailItemVm.imageUrl = ""
                                                    showImagePicker.toggle()
                                                }label: {
                                                    Image(systemName: "photo.tv")
                                                    Text("Foto ändern")
                                                }
                                            }
                                            .frame(
                                                minWidth: 300,
                                                minHeight: 200)
                                        } else {
                                            if calendarDetailItemVm.selectedImage != nil {
                                                VStack{
                                                    Image(uiImage: calendarDetailItemVm.selectedImage!)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .cornerRadius(10)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .stroke(Color.cyan, lineWidth: 2)
                                                        )
                                                    Button{
                                                        showImagePicker.toggle()
                                                    }label: {
                                                        Image(systemName: "photo.tv")
                                                        Text("Foto ändern")
                                                    }
                                                }
                                                .frame(
                                                    minWidth: 300,
                                                    minHeight: 200)
                                            } else {
                                                VStack{
                                                    Button{
                                                        showImagePicker.toggle()
                                                    }label: {
                                                        Image(systemName: "photo.tv")
                                                        Text("Foto hinzufügen oder ändern")
                                                    }
                                                }
                                                .frame(
                                                    minWidth: 300,
                                                    minHeight: 150)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(Color.cyan, lineWidth: 2)
                                                )
                                                .padding(0)
                                            }
                                        }
                                    }
                                }
                                Divider()
                                //Ab hier Text für die Erlebnisse
                                VStack{
                                    Text("3. Beschreibe deine Erlebnisse")
                                        .font(.callout)
                                        .padding(
                                            EdgeInsets(
                                                top: 2,
                                                leading: 0,
                                                bottom: -6,
                                                trailing: 0))
                                    TextField("", text: $calendarDetailItemVm.logBookText, axis: .vertical)
                                        .background(Color.clear)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(7...10000)
                                        .font(.system(size: 17).bold())
                                        .autocorrectionDisabled()
                                        .padding(
                                            EdgeInsets(
                                                top: 5,
                                                leading: 6,
                                                bottom: 2,
                                                trailing: 6))
                                        .frame(
                                            width: 300,
                                            height: 150)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.cyan, lineWidth: 2)
                                        )
                                        .focused($isInputActive)
                                        .toolbar {
                                            ToolbarItemGroup(placement: .keyboard) {
                                                Spacer()
                                                
                                                Button("Fertig") {
                                                    isInputActive = false
                                                }
                                            }
                                        }
                                }
                            }
                            .frame(
                                width: 300,
                                alignment: .center)
                            .padding(15)
                        }
                        Divider()
                        VStack{
                            //Button zum speichern von Bildern
                            ButtonTextAction(iconName: "square.and.arrow.down", text: "Speichern") {
                                //Wenn Einträge nicht leer sind oder Einträge mit nicht leeren Text und das passende Datum enthalten, existieren
                                if !calendarDetailItemVm.newEntryLogs.isEmpty || calendarDetailItemVm.newEntryLogs.contains(where: { !$0.logBookText.isEmpty && $0.formattedDate == calendarDetailItemVm.formattedDate }) {
                                    calendarDetailItemVm.deleteLogBookText(formattedDate: calendarDetailItemVm.formattedDate)
                                    //Bilder löschen nur wenn eine Url existiert, sonst übersprinten
                                    if !calendarDetailItemVm.imageUrl.isEmpty {
                                        calendarDetailItemVm.deleteImage(imageUrl: calendarDetailItemVm.newEntryLogs.first?.imageUrl ?? "no image found")
                                    }
                                    calendarDetailItemVm.removeListener()
                                    showSuccessfulUploadAlert.toggle()
                                    calendarDetailItemVm.createlogBookText(logBookText: calendarDetailItemVm.logBookText)
                                    if notificationsOn {
                                        calendarDetailItemVm.triggerSuccessVibration()
                                    }
                                    calendarDetailItemVm.stopLocationRequest()
                                } else {
                                    addActivity()
                                    showSuccessfulUploadAlert.toggle()
                                    calendarDetailItemVm.createlogBookText(logBookText: calendarDetailItemVm.logBookText)
                                    if notificationsOn {
                                        calendarDetailItemVm.triggerSuccessVibration()
                                    }
                                    calendarDetailItemVm.stopLocationRequest()
                                }
                            }
                        }
                    }
                    VStack(alignment: .trailing){
                        if entryButtonIsActive {
                            Button{
                                showToDoSheet.toggle()
                            } label: {
                                CalendarInfoButtonView()
                            }
                            .rotationEffect(Angle(degrees: isAnimated ? -0 : 20))
                            .animation(
                                Animation
                                    .easeInOut(duration: 0.3)
                                    .repeatCount(7, autoreverses: true), value: isAnimated)
                        }
                    }
                    .offset(x: 130, y: 180)
                    .onAppear {
                        isAnimated = true
                    }
                }
                Divider()
            }
            .navigationBarTitle("Neuer Logbuch Eintrag")
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
            .background(
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.2)
                    .ignoresSafeArea(.all))
            .toolbar{
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading){
                    Button("Zurück"){
                        showNewEntryView.toggle()
                    }
                }
                if isInputActive {
                    ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing){
                        Button("Fertig"){
                            isInputActive = false
                        }
                    }
                }
            }
        }
        .onAppear {
            calendarDetailItemVm.requestLocation()
        }
//        .sheet(
//            isPresented: $showUserChoiceAnnotation,
//            onDismiss: nil) {
//            MapKitUserAnnotationView()
//                .presentationDetents([.large])
//        }
        .onDisappear{
            calendarDetailItemVm.stopLocationRequest()
            isAnimated = false
        }
        .sheet(
            isPresented: $showImagePicker,
            onDismiss: nil) {
                ImagePicker(
                    selectedImage: $calendarDetailItemVm.selectedImage,
                    showImagePicker: $showImagePicker)
            }
            .sheet(
                isPresented: $showToDoSheet,
                onDismiss: nil) {
                    CalendarNewEntrySheetView(showToDoSheet: $showToDoSheet)
                        .presentationDetents([.medium])
                }
                .alert(
                    isPresented:  $showSuccessfulUploadAlert){
                        Alert(
                            title: Text("Deine Daten werden auf den Server geladen"),
                            message: Text("gedulde Dich einen Moment"),
                            dismissButton: .default(Text("OK"), action: {
                                showNewEntryView.toggle()
                            })
                        )
                    }
                    .toolbar(.hidden, for: .tabBar)
                    .background(Color(UIColor.systemBackground))
    }
    
    func addActivity(){
        let item = LogBookAtivity(
            date: calendarDetailItemVm.date,
            isNotEmpty: true,
            userId: FirebaseManager.shared.userId!)
        context.insert(item)
    }
}

#Preview{
    CalendarDetailNewEntryView(calendarDetailItemVm: CalendarDetailItemViewModel(calendarItemModel: LogBookModel(userId: "", formattedDate: "", logBookText: "", latitude: 0.0, longitude: 0.0, imageUrl: "", containsLogBookEntry: false), date: Date()), showNewEntryView: .constant(false))
        .modelContainer(for: [LogBookAtivity.self])
}
