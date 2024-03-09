//
//  ProfileScreenView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 06.03.24.
//

import SwiftUI

struct ProfileScreenView: View {
    
    @EnvironmentObject var authVm: AuthViewModel
    
    var body: some View {
        let userName = authVm.user?.userName ?? "User unbekannt"
        let userEmail = authVm.user?.email ?? "Email unbekannt"
        NavigationStack {
            VStack {
                // Hier kannst du den Inhalt deiner Profilansicht einfügen
                Text("Profil Ansicht!")
                Spacer()
                Text("eingeloggt als:")
                Text(userName)
                    .font(.largeTitle)
                Spacer()
                
                Text("mit der Email:")
                Text(userEmail)
                    .font(.largeTitle)
                Spacer()
            }
            .toolbar {
                Button {
                    authVm.logout()
                } label: {
                    Text("Logout")
                    Image(systemName: "door.left.hand.open")
                }
            }
            .navigationBarTitle("Profil") // Optional: Setzt den Titel der Navigationsleiste
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
                    .ignoresSafeArea())
        }
    }
}

#Preview {
    ProfileScreenView()
        .environmentObject(AuthViewModel())
}
