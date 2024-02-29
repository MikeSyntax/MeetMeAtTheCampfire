//
//  MeetMeAtTheCampfireApp.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 28.02.24.
//

import SwiftUI
import Firebase


@main
struct MeetMeAtTheCampfireApp: App {
    
    @StateObject var authVm = AuthViewModel()
    
    init(){
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if authVm.userLoggedIn {
                ContentView()
                    .environmentObject(authVm)
            } else {
                LoginView()
                    .environmentObject(authVm)
            }
           
        }
    }
}
