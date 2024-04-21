//
//  SettingsScreenView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 06.03.24.
//

import SwiftUI

struct SettingsScreenView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isDarkMode") var isDark: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
                Button{
                    isDark.toggle()
                }label: {
                    isDark ? Label("Lightmode", systemImage: "lightbulb.fill") : Label("Darkmode", systemImage: "lightbulb")
                }
                .buttonStyle(.borderedProminent)
                .offset(x: 0, y: -150)
                Spacer()
            }
            .toolbar{
                Button("abbrechen"){
                    dismiss()
                }
            }
            .navigationTitle("Settings")
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
                    .ignoresSafeArea(.all))
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
    }
}

#Preview {
    SettingsScreenView()
}
