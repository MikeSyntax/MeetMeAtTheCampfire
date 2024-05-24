//
//  LanguageRepository.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 08.03.24.
//

import Foundation

@MainActor
final class LanguageRepository {
    
    //Funktion um eine Zielsprache der API auszuwählen und als Array zurückzugeben
    func languages() async throws -> [Language] {
        guard let url = URL(string: "https://text-translator2.p.rapidapi.com/getLanguages") else {
            throw LanguageUrlError()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(LanguageApiKey.languageApiKey, forHTTPHeaderField: "X-RapidAPI-Key")
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        //Zugriff auf das Language Model
        let languageResult = try JSONDecoder().decode(LanguageResult.self, from: data)
        
        return languageResult.data.languages
    }
    
    //Funktion den eingegebenen Text in der API zu übersetzen und zurückzugeben
    func translate(languageSource: String, languageChoice: String, textToTranslate: String) async throws -> String {
        guard let url = URL(string: "https://text-translator2.p.rapidapi.com/translate") else {
            throw LanguageUrlError()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(LanguageApiKey.languageApiKey, forHTTPHeaderField: "X-RapidAPI-Key")
        
        //PostMethode da der Body mitgeschickt werden muss um den Text zu übersetzen
        urlRequest.httpMethod = "POST"
        // Erstellen Sie den HTTP-Body direkt bei der Erstellung der Anfrage
        let httpBodyString = "source_language=\(languageSource)&target_language=\(languageChoice)&text=\(textToTranslate)"
        //der Body akzeptiert nur Daten deshalb wird der String mit utf8 in Daten umgewandelt und mit der post Methode verschickt
        urlRequest.httpBody = httpBodyString.data(using: .utf8)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        //Zugriff auf das Translation Model
        let translation = try JSONDecoder().decode(Translation.self, from: data)
        
        return translation.data.translatedText
    }
}

