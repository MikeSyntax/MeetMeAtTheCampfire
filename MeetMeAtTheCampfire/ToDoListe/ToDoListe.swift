//
//  ToDoListe.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 08.03.24.
//

//Aufgaben
//Die Monate sind nicht alle auf Deutsch
//Koordinaten für die eigene Location mit var anlegen um diese beim ersten Mal einzugeben
//Task für die Kategorien einbauen ERLEDIGT-----------------------------------------------------------------------------------------------------------
//Anzeige der ungelesenen Nachrichten. ERLEDIGT-------------------------------------------------------------------------------------------------------
//Die Sprache aus dem Picker wird nicht geändert. ERLEDIGT--------------------------------------------------------------------------------------------
//Button soll verschwinden wenn logBookText vorhanden ist ERLEDIGT------------------------------------------------------------------------------------
//Logbuch für tägliches Tagebuch oder Einträge was passiert ist nach Kalendertagen sortiert ERLEDIGT--------------------------------------------------
//Abstand zur View oben zu groß in der CalendarDetailView ERLEDIGT------------------------------------------------------------------------------------

//Die Zahl der Tasks muss in der Kategorie angezeigt werden
//Beim Einloggen muss man manchmal erst zwischen den Screen wechseln bevor sich die Ansicht aktualisiert
//Die Suche im Chat soll an einen bestimmten chat springen, wenn es geht
//im ChatViewModel eine Funktion bauen die alle Nachrichten nach dem gesuchten Text filtert und dann den Index nach dem Text nachschlagen, wenn es Treffenr gibt ist der Weiter button sichtbar, mit @State für Highlight Index. mit dem Id-Modifier an den Nachrichten nach der Id suchen
//TabBar Kalender YearlyView nicht mit Hintergrund
//MapView Koordianten übergeben an die Ansicht
//blauer Punkt wenn ein Eintrag in der Kalenderview mit Daten befüllt ist
//Bildergröße in der KalenderView
//Seite muss sich aktualisieren sobald Bilder hochgeladen wurden
//man muss immer ein Foto mit eingeben sonst wird auch kein TExt angezeigt
//Die Task lassen sich nur erledigen, aber nicht zurück auf unerledigt
//Profil ausbauen
//Settings mit Account löschen
//Beim Chat die Box automatisch der Nachricht anpassen
//AsyncImage mit Url nicht und mit UIImage in Storage speichern
//Höhe des Feldes für die Übersetzung



//MARK ----

//struct CalendarYearlyView: View {
//
//    @State private var year = Date().getFirstDateOfYear()
//    @State private var scrollPosition: Int? = nil
//
//    var body: some View {
//        NavigationStack{
//            VStack{
//                Divider()
//                ScrollView {
//                    VStack{
//                        WeekdayHeaderView()
//                        ForEach(year.getAllMonths(), id:  \.self) { month in
//                            CalendarMonthlyView(month: month)
//                                .id(month.get(.month))
//                        }
//                    }
//                }
//            }
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing){
//                    YearSwitcher(year: $year)
//                }
//            }
//            .onAppear {
//                scrollPosition = Int(Date().get(.month))
//            }
//            .scrollPosition(id: $scrollPosition)
//            .navigationTitle("Logbuch \(CalendarUtils.getYearCaption(year))")
//            .scrollContentBackground(.hidden)
//            .background(
//                Image("background")
//                    .resizable()
//                    .scaledToFill()
//                    .opacity(0.2)
//                    .ignoresSafeArea(.all))
//        }
//    }
//}
//
//#Preview{
//    CalendarYearlyView()
//}
//
//private struct WeekdayHeaderView: View {
//
//    private var weekdays = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"]
//    let columns = Array(repeating: GridItem(.flexible()), count: 7)
//
//    var body: some View{
//        LazyVGrid(columns: columns, spacing: 25){
//            ForEach(weekdays, id: \.self) { weekday in
//                Text(weekday)
//            }
//        }
//    }
//}
//
//private struct YearSwitcher: View {
//    @Binding var year: Date
//
//    var body: some View{
//        HStack{
//            Button("-"){
//                year = year.getPreviousYear()
//            }
//            Text(CalendarUtils.getYearCaption(year))
//            Button("+"){
//                year = year.getNextYear()
//            }
//        }
//    }
//}


//if #available(iOS 15.0, *) {
//    let tabBarAppearance = UITabBarAppearance()
//    tabBarAppearance.backgroundColor = UIColor.clear // Setze die Hintergrundfarbe auf cyan
//    UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
//}

// Aus der CalendarDeteilItemView für die edit Funktion
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button {
//                        calendarDetailItemVm.updateLogBookText()
//                    } label: {
//                        Text("Edit")
//                        Image(systemName: "pencil")
//                            .font(.caption)
//                            .bold()
//                    }
//                }
//            }

//import SwiftUI
//
//struct CalendarMonthlyView: View {
//
//    @ObservedObject var calendarDetailItemVm: CalendarDetailItemViewModel
//    let columns = Array(repeating: GridItem(.flexible()), count: 7)
//    var month: Date
//
//    var body: some View {
//        VStack{
//            Text(CalendarUtils.getMonthCaption(month))
//                .font(.title2)
//                .padding(.leading, 12)
//                .frame(maxWidth: .infinity, alignment: .leading)
//
//            LazyVGrid(columns: columns, spacing: 25) {
//                ForEach(0..<month.getWeekday(), id: \.self) { _ in
//                    Spacer()
//                }
//
//                ForEach(month.getAllDaysToNextMonth(), id: \.self){ day in
//                    NavigationLink(destination: CalendarDetailItemView(calendarDetailItemVm: CalendarDetailItemViewModel(calendarItemModel: LogBookModel(userId: calendarDetailItemVm.userId, formattedDate: calendarDetailItemVm.formattedDate, logBookText: calendarDetailItemVm.logBookText, latitude: calendarDetailItemVm.latitude, longitude: calendarDetailItemVm.longitude, imageUrl: calendarDetailItemVm.imageUrl, containsLogBookEntry: calendarDetailItemVm.containsLogBookEntry), date: day))) {
//                        CalendarDailyView(date: day)
//                    }
//                }
//            }
//        }
//    }
//}



//    @State private var searchAlertIsShowed: Bool = false

//            .toolbar {
//                Button{
//                    searchAlertIsShowed.toggle()
//                } label: {
//                    Text("Suche")
//                    Image(systemName: "magnifyingglass")
//                }
//            }
//            .alert("Neue Chatsuche", isPresented: $searchAlertIsShowed) {
//                if SettingsScreenView().isDark {
//                    TextField("Suchtext", text: Binding(
//                        get: { chatVm.searchTerm },
//                        set: { chatVm.searchTerm = $0.lowercased() }
//                    ))
//                    .lineLimit(1)
//                    .foregroundColor(.black)
//                    .textInputAutocapitalization(.never)
//                    .autocorrectionDisabled()
//                    Button("zurück") {
//                        searchAlertIsShowed.toggle()
//                        chatVm.searchTerm = ""
//                    }
//                } else {
//                    TextField("Suchtext", text: Binding(
//                        get: { chatVm.searchTerm },
//                        set: { chatVm.searchTerm = $0.lowercased() }
//                    ))
//                    .lineLimit(1)
//                    .foregroundColor(.black)
//                    .textInputAutocapitalization(.never)
//                    .autocorrectionDisabled()
//                    Button("zurück") {
//                        searchAlertIsShowed.toggle()
//                        chatVm.searchTerm = ""
//                    }
//                }
//            }


//            .toolbar {
//                Button{
//                    //todo Search
//                } label: {
//                    Text("Suche")
//                    Image(systemName: "magnifyingglass")
//                }
//            }

//    @StateObject var dateVm = {
//        let calendar = Calendar.current
//        let currentDate = Date()
//        let components = calendar.dateComponents([.year, .month], from: currentDate)
//        return CalendarViewModel(date: calendar.date(from: components) ?? Date())}()

//.onChange(of: chatVm.searchTerm) { newSearchTerm, _ in
//    if !newSearchTerm.isEmpty {
//        chatVm.readMessages()
//        matchingChatIds = chatVm.searchMessages(for: newSearchTerm)
//        print("matchingIds \(matchingChatIds)")
//    }
//}

//    func readSearchedMessages(serchTerm: String) {
//        guard let userId = FirebaseManager.shared.userId else {
//            return
//        }
//
//        self.listener = FirebaseManager.shared.firestore.collection("messages")
//            .whereField("messageText", arrayContains: serchTerm)
//            .addSnapshotListener { querySnapshot, error in
//                if let error = error {
//                    print("Error reading messages: \(error)")
//                    return
//                }
//
//                guard let documents = querySnapshot?.documents else {
//                    print("Query Snapshot is empty")
//                    return
//                }
//
//                let messages = documents.compactMap { document in
//                    try? document.data(as: ChatModel.self)
//                }
//
//                let chatSearchModels = messages.map { message in
//                    let isCurrentUser = message.userId == userId // Überprüfen, ob der Absender der eingeloggte Benutzer ist
//                    return ChatSenderViewModel(chatDesign: message, isCurrentUser: isCurrentUser)
//                }
//                self.chatSearchModels = chatSearchModels
//            }
//    }

//ProfileScreenView(onLogout: { selectedTab = 0 })
//    .tabItem {
//        Image(systemName: "person")
//        Text("Profil")
//    }.tag(4)

//After Logout start with selectedTab
//var onLogout: (()-> Void)?

//                    if chatSenderVm.isLiked {
//                        Button{
//                            chatSenderVm.isLiked.toggle()
//                            chatSenderVm.updateIsLikedStatus(chatSenderVm: chatSenderVm)
//                        } label: {
//                            Image(systemName: "star.fill")
//                                .frame(alignment: chatSenderVm.isCurrentUser ? .trailing : .leading)
//                                .bold()
//                        }
//                    } else {
//                        Button{
//                            chatSenderVm.isLiked.toggle()
//                            chatSenderVm.updateIsLikedStatus(chatSenderVm: chatSenderVm)
//                        } label: {
//                            Image(systemName: "star")
//                                .frame(alignment: chatSenderVm.isCurrentUser ? .trailing : .leading)
//                                .bold()
//                        }
//                   }

//    func updateIsLikedStatus(chatSenderVm: ChatSenderViewModel) {
//        guard let messageId = chatSenderVm.chatSenderVm.id else {
//            return
//        }
//
//        let messagesBox = ["isLiked" : chatSenderVm.isLiked ? false : true]
//        //chatSenderVm.isLiked.toggle()
//        do {
//            try
//            FirebaseManager.shared.firestore.collection("messages").document(messageId).setData(from: messagesBox, merge: true) { error in
//                if let error {
//                    print("update isLikedStatus failed: \(error)")
//                } else {
//                    print("update isLikedStatus done")
//                }
//            }
//        }catch {
//            print("update task failed: \(error)")
//        }
//    }

//                    Image(systemName: detailCategorieItemVm.taskIsDone ? "checkmark.circle" : "circle")
//                        .font(.title)
//                        .foregroundColor(color)

/*, calendarDetailItemVm: CalendarDetailItemViewModel(calendarItemModel: LogBookModel(userId: calendarDetailItemVm.userId, formattedDate: calendarDetailItemVm.formattedDate, logBookText: calendarDetailItemVm.logBookText, latitude: calendarDetailItemVm.latitude, longitude: calendarDetailItemVm.longitude, imageUrl: calendarDetailItemVm.imageUrl, containsLogBookEntry: calendarDetailItemVm.containsLogBookEntry), date: day))*/

// else if hasLogBookText {
//                            Circle()
//                                .frame(width: 30, height: 30)
//                                .foregroundStyle(.blue)
//
//                        }

//@ObservedObject var calendarDetailItemVm: CalendarDetailItemViewModel

//    var hasLogBookText: Bool {
//        calendarDetailItemVm.readLogBookText(formattedDate: calendarDetailItemVm.formattedDate)
//        return calendarDetailItemVm.newEntryLogs.contains{
//            $0.logBookText != "" && !$0.logBookText.isEmpty && $0.formattedDate == calendarDetailItemVm.formattedDate
//        }
//    }


//#Preview("Heute") {
//    CalendarDailyView(dateVm: CalendarViewModel(date: Date()), calendarDetailItemVm: CalendarDetailItemViewModel(calendarItemModel: LogBookModel(userId: "1", formattedDate: "", logBookText: "", latitude: 0.0, longitude: 0.0, imageUrl: "", containsLogBookEntry: false), dateVm: CalendarViewModel(date: Date())))
//}
//
//#Preview("Wochenende") {
//    CalendarDailyView(dateVm: CalendarViewModel(date: Date(timeIntervalSince1970: TimeInterval(1711900977))), calendarDetailItemVm: CalendarDetailItemViewModel(calendarItemModel: LogBookModel(userId: "1", formattedDate: "", logBookText: "", latitude: 0.0, longitude: 0.0, imageUrl: "", containsLogBookEntry: false), dateVm: CalendarViewModel(date: Date())))
//}
//
//#Preview("Log is true") {
//    CalendarDailyView(dateVm: CalendarViewModel(date: Date(timeIntervalSince1970: TimeInterval(1713117721))), calendarDetailItemVm: CalendarDetailItemViewModel(calendarItemModel: LogBookModel(userId: "1", formattedDate: "14.04.2024", logBookText: "12", latitude: 0.0, longitude: 0.0, imageUrl: "", containsLogBookEntry: true), dateVm: CalendarViewModel(date: Date())))
//}



//struct VideoStartCategoriesView: UIViewControllerRepresentable {
//    var shouldPlay: Bool
//
//    func makeUIViewController(context: Context) -> VideoStartCategories {
//        return VideoStartCategories(shouldPlay: shouldPlay)
//    }
//
//    func updateUIViewController(_ uiViewController: VideoStartCategories, context: Context) {
//        uiViewController.shouldPlay = shouldPlay
//    }
//}
//
//class VideoStartCategories: UIViewController {
//    private var player: AVPlayer?
//    var shouldPlay: Bool = true {
//        didSet {
//            if shouldPlay {
//                player?.play()
//            } else {
//                player?.pause()
//            }
//        }
//    }
//
//    init(shouldPlay: Bool) {
//        self.shouldPlay = shouldPlay
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        guard let url = Bundle.main.url(forResource: "Cat", withExtension: "MP4") else {
//            return
//        }
//
//        player = AVPlayer(url: url)
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.videoGravity = .resizeAspect
//        playerLayer.frame = view.bounds
//        view.layer.addSublayer(playerLayer)
//        player?.volume = 0
//
//        if shouldPlay {
//            player?.play()
//        }
//
//        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
//    }
//
//    @objc func playerItemDidReachEnd(notification: Notification) {
//        if let playerItem = notification.object as? AVPlayerItem {
//            playerItem.seek(to: .zero, completionHandler: nil)
//            player?.play()
//        }
//    }
//
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//}



//import SwiftUI
//
//struct ContentView: View {
//    @State private var imageOffsets: [CGSize] = {
//        if let storedOffsets = UserDefaults.standard.array(forKey: "ImageOffsets") as? [[CGFloat]] {
//            return storedOffsets.map { CGSize(width: $0[0], height: $0[1]) }
//        } else {
//            return [.zero, .zero, .zero]
//        }
//    }()
//    @State private var draggingIndex: Int?
//
//    var body: some View {
//        VStack {
//            Spacer()
//            HStack {
//                ForEach(0..<3) { index in
//                    Image(systemName: "photo")
//                        .font(.largeTitle)
//                        .padding()
//                        .background(Color.blue)
//                        .clipShape(Circle())
//                        .offset(imageOffsets[index])
//                        .gesture(
//                            DragGesture()
//                                .onChanged { value in
//                                    draggingIndex = index
//                                    imageOffsets[index] = value.translation
//                                }
//                                .onEnded { _ in
//                                    draggingIndex = nil
//                                    saveImageOffsets()
//                                }
//                        )
//                }
//            }
//            .padding()
//            Spacer()
//        }
//        .edgesIgnoringSafeArea(.all)
//    }
//
//    func saveImageOffsets() {
//        let offsetsToSave = imageOffsets.map { [$0.width, $0.height] }
//        UserDefaults.standard.set(offsetsToSave, forKey: "ImageOffsets")
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}




//func updateIsLikedStatus(chatSenderVm: ChatSenderViewModel) {
//    guard let messageId = chatSenderVm.chatSenderVm.id else {
//        return
//    }
//    
//    guard let userId = FirebaseManager.shared.userId else {
//        return
//    }
//    
//    if !chatSenderVm.isLikedByUser.contains(userId){
//        chatSenderVm.isLikedByUser.append(userId)
//    }
//    
//    chatSenderVm.isLiked.toggle()
//    
//    let isLiked = !chatSenderVm.isLiked
//    let isLikedByUser = chatSenderVm.isLikedByUser
//    
//    let messagesBox: [String: Any] = ["isLiked": isLiked, "isLikedByUser": isLikedByUser.map({$0}), "userId": userId]
//    
//    FirebaseManager.shared.firestore.collection("messages").document(messageId).updateData(messagesBox) { error in
//        if let error {
//            print("update isLikedStatus failed: \(error)")
//        } else {
//            print("update isLikedStatus done")
//        }
//    }
//}

    // Überprüfen, ob der Benutzer bereits im Array isLikeByUser enthalten ist
//    let userIndex = chatSenderVm.isLikeByUser.firstIndex(of: userId)
//    
//    // Wenn die Nachricht gemocht wurde und der Benutzer nicht im Array enthalten ist, füge ihn hinzu
//    if chatSenderVm.isLiked && userIndex == nil {
//        chatSenderVm.isLikeByUser.append(userId)
//    }
//    
//    // Wenn die Nachricht nicht gemocht wurde und der Benutzer im Array enthalten ist, entferne ihn
//    if !chatSenderVm.isLiked && userIndex != nil {
//        chatSenderVm.isLikeByUser.remove(at: userIndex!)
//    }
//    
//    // Ändern des isLiked-Status
//    chatSenderVm.isLiked.toggle()
//    
//    // Erstellen des Nachrichtenobjekts für die Aktualisierung in Firestore
//    let messagesBox: [String: Any] = ["isLiked": chatSenderVm.isLiked,
//                                      "isLikedByUser": chatSenderVm.isLikeByUser,
//                                      "userId": userId]
//    
//    // Aktualisierung der Nachrichtendaten in Firestore
//    FirebaseManager.shared.firestore.collection("messages").document(messageId).setData(messagesBox, merge: true) { error in
//        if let error = error {
//            print("update isLikedStatus failed: \(error)")
//        } else {
//            print("update isLikedStatus done")
//        }
//    }
//}
