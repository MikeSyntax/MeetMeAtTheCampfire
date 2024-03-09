//
//  LanguageScreenViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 09.03.24.
//

import Foundation

class LanguageScreenViewModel: ObservableObject {
    
    private let translatorRepo: TranslatorRepository
    
    @Published var languages: [Language] = []
    
    @Published var textToTranslate: String = ""
    @Published var translatedText: String = ""
    
    var languageChoice: Language
    
    init(languageChoice: Language) {
        self.translatorRepo = TranslatorRepository()
        self.languageChoice = languageChoice
        
        languages = [
            Language(code: "ru", name: "russisch"),
            Language(code: "es", name: "spanisch"),
            Language(code: "hr", name: "kroatisch")
        ]
    }
    
    @MainActor
    func loadLanguages(){
        Task{
            do{
                let languages = try await self.translatorRepo.languages()
                self.languages = languages
            } catch {
                print("Error: \(error)")
            }
        }
    }
    @MainActor
    func translate(){
        Task{
            do{
                self.translatedText = try await self.translatorRepo.translate(languageSource: "de", languageChoice: self.languageChoice.code, textToTranslate: textToTranslate)
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
