//
//  ToDoListe.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 08.03.24.
//

import Foundation

//Aufgaben

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
