//
//  SettingsScreenView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 06.03.24.
//

import SwiftUI

struct SettingsScreenView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("infoButton") private var infoButtonIsActive: Bool = true
    @AppStorage("entryButton") private var entryButtonIsActive: Bool = true
    @AppStorage("colorScheme") private var colorScheme: String = "System"
    @State var showPrivacySheet = false
    
    var body: some View {
        NavigationStack{
            VStack{
                Toggle("Info Kalender einblenden ", systemImage: "info.square", isOn: $infoButtonIsActive)
                    .padding()
                    .frame(maxHeight: 70)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.cyan, lineWidth: 2)
                    )
                
                Toggle("Info Logbuch einblenden ", systemImage: "info.square", isOn: $entryButtonIsActive)
                    .padding()
                    .frame(maxHeight: 70)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.cyan, lineWidth: 2)
                    )
                
                VStack(alignment: .leading){
                    Text("Erscheinungsbild")
                        .underline()
                    Toggle("Licht aus", systemImage: "lightbulb", isOn: Binding(
                        get: { colorScheme == "Dark" },
                        set: { newValue in
                            colorScheme = newValue ? "Dark" : "System"
                        }
                    ))
                    Toggle("Licht an", systemImage: "lightbulb.fill", isOn: Binding(
                        get: { colorScheme == "Light" },
                        set: { newValue in
                            colorScheme = newValue ? "Light" : "System"
                        }
                    ))
                    Toggle("Nach System", systemImage: "apple.logo", isOn: Binding(
                        get: { colorScheme == "System" },
                        set: { newValue in
                            colorScheme = newValue ? "System" : "Light"
                        }
                    ))
                }
                .padding()
                .frame(maxHeight: 170)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.cyan, lineWidth: 2)
                )
                
                HStack{
                    Spacer()
                    Button("Impressum"){
                        //Todo Impressum
                    }
                    Spacer()
                }
                .frame(maxHeight: 70)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.cyan, lineWidth: 2)
                )
                
                HStack{
                    Spacer()
                    Button("Datenschutz"){
                        showPrivacySheet.toggle()
                    }
                    Spacer()
                }
                .frame(maxHeight: 70)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.cyan, lineWidth: 2)
                )
                .sheet(isPresented: $showPrivacySheet){
                    PrivacySheet(showPrivacySheet: $showPrivacySheet)
                        .presentationDetents([.large])
                }
                Spacer()
                Divider()
                Spacer()
                
                HStack{
                    Spacer()
                    ButtonDestructiveTextAction(iconName: "trash", text: "Account löschen"){
                        //Todo Account löschen
                    }
                    Spacer()
                }
                .frame(maxHeight: 70)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.cyan, lineWidth: 2)
                )
                //Ende VStack
            }
            .padding(EdgeInsets(top: 30, leading: 20, bottom: 20, trailing: 20))
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
        .onChange(of: colorScheme) { _, newColorScheme in
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let window = windowScene.windows.first
                if newColorScheme == "Dark" {
                    window?.overrideUserInterfaceStyle = .dark
                } else if newColorScheme == "Light" {
                    window?.overrideUserInterfaceStyle = .light
                } else {
                    window?.overrideUserInterfaceStyle = .unspecified
                }
            }
        }
        .background(Color(UIColor.systemBackground))
    }
}

#Preview {
    SettingsScreenView()
}

