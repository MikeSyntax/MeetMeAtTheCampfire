//
//  SettingsScreenView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 06.03.24.
//

import SwiftUI

struct SettingsScreenView: View {
    
    @AppStorage("infoButton") private var infoButtonIsActive: Bool = true
    @AppStorage("entryButton") private var entryButtonIsActive: Bool = true
    @AppStorage("colorScheme") private var colorScheme: String = "System"
    @AppStorage("badgevisible") private var isBadgeVisible: Bool = true
    @AppStorage("notifications") private var notificationsOn: Bool = true
    @AppStorage("userIsPremium") private var userIsPremium: Bool = false
    @State private var showPrivacySheet: Bool = false
    @State private var showDeleteAccountAlert: Bool = false
    @State private var showReEnterPasswordAlert: Bool = false
    @State private var showPasswordConfirmationSheet: Bool = false
    @State private var showBlockedUserSheet: Bool = false
    @EnvironmentObject var authVm: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack{
            VStack{
                Divider()
                ScrollView{
                    Spacer()
                    VStack{
                        Toggle("Benutzer hat die Pro Version", systemImage: userIsPremium ? "person.badge.key.fill" : "person.badge.key", isOn: $userIsPremium)
                            .font(.system(size: 15))
                            .padding()
                            .frame(minHeight: 70)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.cyan, lineWidth: 2)
                            )
                        
                        Toggle("Info Kalender einblenden ", systemImage: infoButtonIsActive ? "info.square.fill" : "info.square", isOn: $infoButtonIsActive)
                            .font(.system(size: 15))
                            .padding()
                            .frame(minHeight: 70)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.cyan, lineWidth: 2)
                            )
                        
                        Toggle("Info Logbuch einblenden ", systemImage: entryButtonIsActive ? "info.square.fill" : "info.square", isOn: $entryButtonIsActive)
                            .font(.system(size: 15))
                            .padding()
                            .frame(minHeight: 70)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.cyan, lineWidth: 2)
                            )
                        
                        VStack(alignment: .leading){
                            Text("Erscheinungsbild")
                                .underline()
                                .font(.system(size: 15))
                            Toggle("Licht aus", systemImage: "lightbulb", isOn: Binding(
                                get: { colorScheme == "Dark" },
                                set: { newValue in
                                    colorScheme = newValue ? "Dark" : "System"
                                }
                            ))
                            .font(.system(size: 15))
                            Toggle("Licht an", systemImage: "lightbulb.fill", isOn: Binding(
                                get: { colorScheme == "Light" },
                                set: { newValue in
                                    colorScheme = newValue ? "Light" : "System"
                                }
                            ))
                            .font(.system(size: 15))
                            Toggle("Nach System", systemImage: "apple.logo", isOn: Binding(
                                get: { colorScheme == "System" },
                                set: { newValue in
                                    colorScheme = newValue ? "System" : "Light"
                                }
                            ))
                            .font(.system(size: 15))
                        }
                        .padding()
                        .frame(minHeight: 170)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.cyan, lineWidth: 2)
                        )
                        
                        Toggle("Vibration bei Erfolg", systemImage: notificationsOn ? "iphone.gen1.radiowaves.left.and.right" : "iphone.gen1.slash", isOn: $notificationsOn)
                            .font(.system(size: 15))
                            .padding()
                            .frame(minHeight: 70)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.cyan, lineWidth: 2)
                            )
                        
                        Toggle("Benachrichtigung Campfire", systemImage: isBadgeVisible ? "flame.fill" : "flame", isOn: $isBadgeVisible)
                            .font(.system(size: 15))
                            .padding()
                            .frame(minHeight: 70)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.cyan, lineWidth: 2)
                            )
                        HStack{
                            Spacer()
                            Button("Meine blockierten User"){
                                showBlockedUserSheet.toggle()
                            }
                            Spacer()
                        }
                        .frame(minHeight: 70)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.cyan, lineWidth: 2)
                        )
                        .sheet(isPresented: $showBlockedUserSheet){
                            BlockedUserSheet(showBlockedUserSheet: $showBlockedUserSheet)
                                .presentationDetents([.medium])
                        }
                        HStack{
                            Spacer()
                            Button(action: {
                                if let url = URL(string: Impressum.impressumKey) {
                                    UIApplication.shared.open(url)
                                }
                            }) {
                                Text("Impressum")
                            }
                            Spacer()
                        }
                        .frame(minHeight: 70)
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
                        .frame(minHeight: 70)
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
                                showDeleteAccountAlert.toggle()
                            }
                            .actionSheet(isPresented: $showDeleteAccountAlert) {
                                ActionSheet(
                                    title: Text("Account wirklich löschen?"),
                                    message: Text("Alle Daten werden unwiederbringlich gelöscht!"),
                                    buttons: [
                                        .cancel(Text("Zurück")),
                                        .destructive(Text("Ja, ich bin sicher"), action: {
                                            showPasswordConfirmationSheet.toggle()
                                        })
                                    ]
                                )
                            }
                            Spacer()
                        }
                        .frame(minHeight: 70)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.cyan, lineWidth: 2)
                        )
                    }
                    .padding(20)
                    Spacer()
                }
                Divider()
            }
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
        .sheet(isPresented: $showPasswordConfirmationSheet, content: {
            DeleteAccountSheet(showPasswordConfirmationSheet: $showPasswordConfirmationSheet)
                .presentationDetents([.medium])
        })
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
        .ignoresSafeArea(.all)
    }
}

#Preview {
    SettingsScreenView()
        .environmentObject(AuthViewModel())
}
