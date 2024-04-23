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
    @State private var selectionSourceLanguage: Language = Language(code: "de", name: "Deutsch")
    
    var body: some View {
        NavigationStack {
            VStack {
                Divider()
                ZStack{
                    Form {
                        Section(header: Text("Wähle hier Deine Zielsprache aus").foregroundStyle(.black)){
                            Picker("Übersetze nach", selection: $selectionLanguage) {
                                ForEach(languageVm.languages, id: \.code) { language in
                                    Text(language.name)
                                        .tag(language)
                                }
                            }
                            .pickerStyle(.menu)
                            .onChange(of: selectionLanguage) { languageVm.languageChoice = selectionLanguage }
                        }
                        Section(header: Text("Text eingeben").foregroundStyle(.black)){
                            TextField("Texteingabe für die Übersetzung", text: $languageVm.textToTranslate, axis: .vertical)
                                .onChange(of: languageVm.textToTranslate) { newValue, _ in
                                    if newValue.count > 300 {
                                        languageVm.textToTranslate = String(newValue.prefix(300))
                                    }
                                }
                                .shadow(color: .cyan, radius: 2)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .lineLimit(1...5)
                                .textFieldStyle(.roundedBorder)
                                .frame(minHeight: 40)
                        }
                        Section(header: Text("Es wird übersetzt von").foregroundStyle(.black)){
                            HStack{
                                Text("\(selectionSourceLanguage.name)")
                                Spacer()
                                ButtonTextAction(iconName: "network", text: "Übersetzen ->"){
                                    languageVm.translateLanguage()
                                }
                                Spacer()
                                Text("\(selectionLanguage.name)")
                            }
                            .frame(maxWidth: .infinity, minHeight: 70, alignment: .center)
                        }
                        Section(header: Text("Übersetzung").foregroundStyle(.black)){
                            TextField("Übersetzung", text: $languageVm.translatedText, axis: .vertical)
                                .shadow(color: .green, radius: 2)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .lineLimit(1...5)
                                .textFieldStyle(.roundedBorder)
                                .frame(minHeight: 40)
                        }
                    }
                }
                Divider()
            }
            .scrollContentBackground(.hidden)
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
                    .ignoresSafeArea(.all))
            .navigationBarTitle("Übersetzer", displayMode: .inline)
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
    let languageVm = LanguageScreenViewModel(languageChoice: Language(code: "de", name: "Deutsch"), languageSource: Language(code: "af", name: "Afrikaans"))
    return LanguageScreenView(languageVm: languageVm)
}
