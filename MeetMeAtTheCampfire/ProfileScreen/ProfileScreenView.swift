//
//  ProfileScreenView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 06.03.24.
//

import SwiftUI

struct ProfileScreenView: View {
    
    @EnvironmentObject var authVm: AuthViewModel
    
    //After Logout start with selectedTab
    //var onLogout: (()-> Void)?
    
    var body: some View {
        let userName = authVm.user?.userName ?? "User unbekannt"
        let userEmail = authVm.user?.email ?? "Email unbekannt"
        NavigationStack {
            VStack {
                Divider()
                Image(.logo)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 250, height: 250)
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
                  //  onLogout?()
                } label: {
                    Text("Logout")
                    Image(systemName: "door.left.hand.open")
                }
            }
            .navigationBarTitle("Profil")
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
