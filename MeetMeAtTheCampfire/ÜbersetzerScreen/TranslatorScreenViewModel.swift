//
//  TranslatorScreenViewModel.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 08.03.24.
//

import Foundation

class TranslatorScreenViewModel: ObservableObject {
    
    private let translatorRepo: TranslatorRepository
    
    @Published var textToTranslate: String = ""
    @Published var translatedText: String = ""
    
    let languageChoice: Language
    
    init(languageChoice: Language){
        self.translatorRepo = TranslatorRepository()
        self.languageChoice = languageChoice
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
