//
//  TranslatorRepository.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 08.03.24.
//

import Foundation

class TranslatorRepository {
    
    //Funktion um eine Zielsprache der API auszuwählen und als Array zurückzugeben
    func languages() async throws -> [Language] {
        guard let url = URL(string: "https://text-translator2.p.rapidapi.com/getLanguages") else {
            throw TranslatorUrlError()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(TranslatorApiKey.translatorApiKey, forHTTPHeaderField: "X-RapidAPI-Key")
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        let languageResult = try JSONDecoder().decode(LanguageResult.self, from: data)
        
        return languageResult.data.languages
    }
    
    //Funktion den eingegebenen Text in der API zu übersetzen und zurückzugeben
    func translate(languageSource: String, languageChoice: String, textToTranslate: String) async throws -> String {
        guard let url = URL(string: "https://text-translator2.p.rapidapi.com/translate") else {
            throw TranslatorUrlError()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(TranslatorApiKey.translatorApiKey, forHTTPHeaderField: "X-RapidAPI-Key")
        
        urlRequest.httpMethod = "POST"
        // Erstellen Sie den HTTP-Body direkt bei der Erstellung der Anfrage
        let httpBodyString = "source_language=\(languageSource)&target_language=\(languageChoice)&text=\(textToTranslate)"
        urlRequest.httpBody = httpBodyString.data(using: .utf8)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        let translation = try JSONDecoder().decode(Translation.self, from: data)
        
        return translation.data.translatedText
    }
}

