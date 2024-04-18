//
//  LanguageScreenViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 09.03.24.
//

import Foundation

class LanguageScreenViewModel: ObservableObject {
    
    private let languageRepo: LanguageRepository
    
    @Published var languages: [Language] = []
    
    @Published var textToTranslate: String = ""
    @Published var translatedText: String = ""
    
    
    var languageChoice: Language
    var languageSource: Language  //Vorbereitung für die Eingabe der Ausgangssprache, falls es mal nicht nicht Deutsch sein soll
    
    init(languageChoice: Language, languageSource: Language) {
        self.languageRepo = LanguageRepository()
        self.languageChoice = languageChoice
        self.languageSource = languageSource
    }
    
    deinit{
        clearTextFields()
    }
    
    //Sprachen laden im Hauptthread durch MainActor und da dort keine await Funktionen laufen muss ein Task darum gebaut werden
    @MainActor
    func loadLanguages(){
        Task{
            do{
                let languages = try await self.languageRepo.languages()
                self.languages = languages
            } catch {
                print("Error loading languagge: \(error)")
            }
        }
    }
    
    //Übersetzung laden im Hauptthread durch MainActor und da dort keine await Funktionen laufen muss ein Task darum gebaut werden
    @MainActor
    func translateLanguage(){
        Task{
            do{
                self.translatedText = try await self.languageRepo.translate(languageSource: "de", languageChoice: self.languageChoice.code, textToTranslate: textToTranslate)
            } catch {
                print("Error translating language: \(error)")
            }
        }
    }
    
    func clearTextFields(){
        textToTranslate = ""
        translatedText = ""
    }
}
