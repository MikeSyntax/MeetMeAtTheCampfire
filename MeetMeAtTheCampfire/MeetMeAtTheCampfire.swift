//
//  MeetMeAtTheCampfireApp.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 28.02.24.
//

import SwiftUI
import Firebase
import SwiftData

@main
struct MeetMeAtTheCampfireApp: App {
    
    @AppStorage("colorScheme") private var colorScheme: String = "System"
    
    @StateObject var authVm = AuthViewModel()
    
    init(){
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if authVm.userLoggedIn {
                MainScreenView()
                    .environmentObject(authVm)
            } else {
                LoginView()
                    .environmentObject(authVm)
            }
        }
        .environment(\.locale, .init(identifier: "de"))
        .modelContainer(for: [LogBookAtivity.self])
    }
}

