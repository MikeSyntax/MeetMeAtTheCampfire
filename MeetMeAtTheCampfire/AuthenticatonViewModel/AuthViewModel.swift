//
//  AuthViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 29.02.24.
//

import Foundation

class AuthViewModel: ObservableObject{
    
    //Öffentliche Variablen, die durch Nutzung des ViewModels auf den Screens bentuzt werden können
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var userName: String = ""
    @Published var loginAlert: Bool = false
    
    //Erstellen eines User gemäß festgelegten UserModel
    @Published var user: UserModel?
    
    //Erstellen einer LoggedIn Variablen die zuerst auf false steht und nach dem einloggen entsprechend geändert wird
    var userLoggedIn: Bool {
        self.user != nil
    }
    
    
    
    
    
    
    
}
