//
//  ContentView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 28.02.24.
//

import SwiftUI
struct ContentView: View {
    
    @EnvironmentObject var authVm: AuthViewModel
    
    var body: some View {
        ButtonTextAction(iconName: "rectangle.portrait.and.arrow.right", text: "Logout"){
            authVm.logout()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
