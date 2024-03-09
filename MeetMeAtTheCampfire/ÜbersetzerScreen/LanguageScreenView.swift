//
//  LanguageScreenView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 09.03.24.
//

import SwiftUI

struct LanguageScreenView: View {
    
    @ObservedObject var languageVm: LanguageScreenViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("Wähle hier Deine Zielsprache aus")){
                        Picker("Übersetze nach", selection: $languageVm.languageChoice) {
                            ForEach(languageVm.languages, id: \.code) { language in
                                Text(language.name)
                                    .tag(language)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                
                    Section(header: Text("Text eingeben")){
                        TextField("Texteingabe für die Übersetzung", text: $languageVm.textToTranslate)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .lineLimit(5, reservesSpace: true)
                            .textFieldStyle(.roundedBorder)
                           
                    }
                    Section(header: Text("Es wird übersetzt von")){
                        HStack{
                            Text("Deutsch")
                            Spacer()
                            ButtonTextAction(iconName: "network", text: "Übersetzen"){
                                languageVm.translate()
                            }
                            Spacer()
                            Text("\(languageVm.languageChoice.name)")
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    Section(header: Text("Übersetzung")){
                        TextField("Übersetzung", text: $languageVm.translatedText)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .lineLimit(5, reservesSpace: true)
                            .textFieldStyle(.roundedBorder)
                    }
                }
            }
            .navigationTitle(Text("Translator"))
        }
        .onAppear {
            languageVm.loadLanguages()
        }
    }
}


#Preview {
    LanguageScreenView(languageVm: LanguageScreenViewModel(languageChoice: Language(code: "de", name: "Englisch")))
}
