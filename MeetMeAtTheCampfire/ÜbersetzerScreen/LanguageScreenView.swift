//
//  LanguageScreenView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 09.03.24.
//

import SwiftUI

struct LanguageScreenView: View {
    
    @ObservedObject var languageVm: LanguageScreenViewModel
    @State private var selectionLanguage: Language = Language(code: "af", name: "Afrikaans")
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack{
                    Form {
                        Section(header: Text("Wähle hier Deine Zielsprache aus")){
                            Picker("Übersetze nach", selection: $selectionLanguage) {
                                ForEach(languageVm.languages, id: \.code) { language in
                                    Text(language.name)
                                        .tag(language)
                                }
                            }
                            .pickerStyle(.menu)
                            .onChange(of: selectionLanguage) { languageVm.languageChoice = selectionLanguage }
                        }
                        Section(header: Text("Text eingeben")){
                            TextField("Texteingabe für die Übersetzung", text: $languageVm.textToTranslate)
                            
                            
                                .shadow(color: .red, radius: 3)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .lineLimit(5, reservesSpace: true)
                                .textFieldStyle(.roundedBorder)
                                .frame(minHeight: 60)
                                .scrollContentBackground(.hidden)
                        }
                        
                        Section(header: Text("Es wird übersetzt von")){
                            HStack{
                                Text("Deutsch")
                                Spacer()
                                ButtonTextAction(iconName: "network", text: "Übersetzen ->"){
                                    languageVm.translateLanguage()
                                }
                                Spacer()
                                Text("\(selectionLanguage.name)")
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                        Section(header: Text("Übersetzung")){
                            TextField("Übersetzung", text: $languageVm.translatedText)
                                .shadow(color: .green, radius: 3)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .lineLimit(5, reservesSpace: true)
                                .textFieldStyle(.roundedBorder)
                                .frame(minHeight: 60)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .background(
                    Image("background")
                        .resizable()
                        .scaledToFill()
                        .opacity(0.2)
                        .ignoresSafeArea())
            }
            .navigationTitle(Text("Translator"))
        }
        .onAppear {
            languageVm.loadLanguages()
        }
        .onDisappear{
            languageVm.clearTextFields()
            selectionLanguage = Language(code: "af", name: "Afrikaans")
        }
    }
}

#Preview {
    LanguageScreenView(languageVm: LanguageScreenViewModel(languageChoice: Language(code: "de", name: "Deutsch"), languageSource: Language(code: "af", name: "Afrikaans")))
}
