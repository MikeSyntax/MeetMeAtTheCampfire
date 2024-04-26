//
//  SettingsScreenView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 06.03.24.
//

import SwiftUI

struct SettingsScreenView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isDarkMode") private var isDark: Bool = false
    @AppStorage("infoButton") private var infoButtonIsActive: Bool = true
    
    var body: some View {
        NavigationStack{
            VStack{
                VStack(alignment: .center){
                    Text("Hell Dunkel Modus")
                    Button{
                        isDark.toggle()
                    }label: {
                        isDark ? Label("Licht anschalten  ", systemImage: "lightbulb.fill") : Label("Licht ausschalten", systemImage: "lightbulb")
                    }
                    .frame(height: 20)
                    .padding(8)
                    .background(.cyan)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .font(.headline)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10) // Erstellen eines gerundeten Rechtecks als Overlay
                            .stroke(Color.white, lineWidth: 2) // Farbe und Breite des Rahmens festlegen
                    )
                    .padding(EdgeInsets(top: -9, leading: 0, bottom: 20, trailing: 20))
                }
                VStack(alignment: .leading){
                    Text("Infobox im Kalender")
                    Button{
                        infoButtonIsActive.toggle()
                    } label: {
                        infoButtonIsActive ? Label("Info ausblenden", systemImage: "info.square") : Label("Info einblenden ", systemImage: "info.square.fill")
                    }
                    .frame(height: 20)
                    .padding(8)
                    .background(.cyan)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .font(.headline)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10) // Erstellen eines gerundeten Rechtecks als Overlay
                            .stroke(Color.white, lineWidth: 2) // Farbe und Breite des Rahmens festlegen
                    )
                    .padding(EdgeInsets(top: -9, leading: 0, bottom: 20, trailing: 20))
                }
                Spacer()
            }
            .padding(.top, 30)
            .toolbar{
                Button("Übernehmen"){
                    dismiss()
                }
            }
            .navigationBarTitle("Einstellungen", displayMode: .inline)
            .scrollContentBackground(.hidden)
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
                    .ignoresSafeArea(.all))
        }
        .preferredColorScheme(isDark ? .dark : .light)
    }
}

#Preview {
    SettingsScreenView()
}

































//import SwiftUI
//
//struct SettingsScreenView: View {
//    @Environment(\.dismiss) private var dismiss
//    @AppStorage("isDarkMode") var isDark: Bool = false
//    @AppStorage("infoButton") private var infoButtonIsActive: Bool = true
//    //--------------
//    var body: some View {
//        NavigationStack{
//            ZStack{
//                Image("background")
//                    .resizable()
//                    .scaledToFill()
//                    .opacity(0.2)
//                    .ignoresSafeArea(.all)
//                VStack{
//                    VStack(alignment: .leading){
//                        Text("Hell Dunkel Modus")
//                        Button{
//                            isDark.toggle()
//                        }label: {
//                            isDark ? Label("Licht anschalten  ", systemImage: "lightbulb.fill") : Label("Licht ausschalten", systemImage: "lightbulb")
//                        }
//                        .padding(EdgeInsets(top: -10, leading: 0, bottom: 20, trailing: 20))
//                        .buttonStyle(.borderedProminent)
//                    }
//                    VStack(alignment: .leading){
//                        Text("Infobox im Kalender")
//                        Button{
//                            infoButtonIsActive.toggle()
//                        } label: {
//                            infoButtonIsActive ? Label("Info ausblenden", systemImage: "info.square") : Label("Info einblenden ", systemImage: "info.square.fill")
//                        }
//                        .padding(EdgeInsets(top: -10, leading: 0, bottom: 20, trailing: 20))
//                        .buttonStyle(.borderedProminent)
//                    }
//                }
//                Spacer()
//            }
//            .toolbar{
//                Button("Übernehmen"){
//                    dismiss()
//                }
//            }
//            .navigationBarTitle("Einstellungen", displayMode: .inline)
//            .scrollContentBackground(.hidden)
////            .background(
////                Image("background")
////                    .resizable()
////                    .scaledToFill()
////                    .opacity(0.2)
////                    .ignoresSafeArea(.all))
//        }
//        .environment(\.colorScheme, isDark ? .dark : .light)
//    }
//}
//
//#Preview {
//    SettingsScreenView()
//}
