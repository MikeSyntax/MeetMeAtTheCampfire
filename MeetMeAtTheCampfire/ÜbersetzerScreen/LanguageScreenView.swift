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
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack{
                Divider()
                ScrollView {
                    VStack(alignment: .leading){
                        Text("Wähle eine Sprache aus".uppercased())
                            .underline()
                            .font(.system(size: 14, design: .monospaced))
                        VStack(alignment: .trailing){
                            ZStack{
                                Text(languageVm.emptyField)
                                Picker("Übersetze nach", selection: $selectionLanguage) {
                                    ForEach(languageVm.languages, id: \.code) { language in
                                        Text(language.name)
                                            .tag(language)
                                    }
                                }
                                .font(.system(size: 17).bold())
                                .textFieldStyle(.roundedBorder)
                                .padding(3)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(10)
                                .frame(minWidth: 310, minHeight: 70)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.cyan, lineWidth: 2)
                                )
                                .pickerStyle(.menu)
                                .onChange(of: selectionLanguage) { languageVm.languageChoice = selectionLanguage }
                            }
                        }
                    }
                    Divider()
                    VStack(alignment: .leading){
                        Text("Text für die Übersetzung eingeben".uppercased())
                            .underline()
                            .font(.system(size: 14, design: .monospaced))
                        VStack(alignment: .trailing){
                            ZStack{
                                if languageVm.textToTranslate.isEmpty {
                                    Text("Hier Text eingeben")
                                        .opacity(0.4)
                                }
                                TextEditor(text: $languageVm.textToTranslate)
                                    .font(.system(size: 17).bold())
                                    .textFieldStyle(.roundedBorder)
                                    .autocorrectionDisabled()
                                    .padding(3)
                                    .frame(width: 310, height: 150)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.cyan, lineWidth: 2)
                                    )
                            }
                            .keyboardType(.default)
                            .submitLabel(.done)
                        }
                    }
                    Divider()
                    VStack(alignment: .leading){
                        Text("Übersetzen von".uppercased())
                            .underline()
                            .font(.system(size: 14, design: .monospaced))
                        HStack{
                            Text("\(selectionSourceLanguage.name)")
                                .font(.system(size: 14))
                                .padding(4)
                            ButtonTextAction(iconName: "network", text: "Übersetzen"){
                                languageVm.translateLanguage()
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                            Text("\(selectionLanguage.name)")
                                .font(.system(size: 14))
                                .padding(4)
                        }
                        .font(.system(size: 17).bold())
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .padding(3)
                        .frame(minWidth: 310, minHeight: 70)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.cyan, lineWidth: 2)
                        )
                    }
                    Divider()
                    if !languageVm.textToTranslate.isEmpty {
                        ZStack{
                            if !isLoading || !languageVm.translatedText.isEmpty {
                                VStack(alignment: .leading){
                                    Text("Ausgabe der Übersetzung".uppercased())
                                        .underline()
                                        .font(.system(size: 14, design: .monospaced))
                                    ZStack{
                                        if languageVm.translatedText.isEmpty {
                                            Text("Übersetzung")
                                                .opacity(0.4)
                                        }
                                        Text(languageVm.translatedText)
                                            .font(.system(size: 17).bold())
                                            .textFieldStyle(.roundedBorder)
                                            .autocorrectionDisabled()
                                            .textInputAutocapitalization(.never)
                                            .padding(3)
                                            .frame(minWidth: 310, minHeight: 150)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.red, lineWidth: 2)
                                            )
                                    }
                                }
                            }
                            if isLoading && languageVm.translatedText.isEmpty {
                                VStack(alignment: .leading){
                                    Text("Ausgabe der Übersetzung".uppercased())
                                        .underline()
                                        .font(.system(size: 14, design: .monospaced))
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .scaleEffect(3)
                                        .frame(minWidth: 310, minHeight: 150)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.red, lineWidth: 2)
                                        )
                                }
                            }
                        }
                        .onAppear{
                            isTranslationIsLoading()
                        }
                    } else {
                        VStack(alignment: .leading){
                            Text("Ausgabe der Übersetzung".uppercased())
                                .underline()
                                .font(.system(size: 14, design: .monospaced))
                            ZStack{
                                if languageVm.translatedText.isEmpty {
                                    Text("Übersetzung")
                                        .opacity(0.4)
                                }
                                Text(languageVm.translatedText)
                                    .font(.system(size: 17).bold())
                                    .textFieldStyle(.roundedBorder)
                                    .autocorrectionDisabled()
                                    .textInputAutocapitalization(.never)
                                    .padding(3)
                                    .frame(minWidth: 310, minHeight: 150)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.red, lineWidth: 2)
                                    )
                            }
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
            .navigationBarTitle("Mein Übersetzer", displayMode: .inline)
            .toolbar{
                Button("Felder leeren"){
                    languageVm.clearTextFields()
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
        .onAppear {
            languageVm.loadLanguages()
        }
        .onDisappear{
            languageVm.clearTextFields()
            selectionLanguage = Language(code: "af", name: "Afrikaans")
        }
        .background(Color(UIColor.systemBackground))
    }
    func isTranslationIsLoading(){
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1000.0){
            isLoading = false
        }
    }
}

#Preview {
    let languageVm = LanguageScreenViewModel(languageChoice: Language(code: "de", name: "Deutsch"), languageSource: Language(code: "af", name: "Afrikaans"))
    return LanguageScreenView(languageVm: languageVm)
}





//
//import SwiftUI
//
//struct LanguageScreenView: View {
//    
//    @ObservedObject var languageVm: LanguageScreenViewModel
//    @State private var selectionLanguage: Language = Language(code: "af", name: "Afrikaans")
//    @State private var selectionSourceLanguage: Language = Language(code: "de", name: "Deutsch")
//    
//    var body: some View {
//        NavigationStack {
//            VStack{
//                Divider()
//                ScrollView {
//                    VStack(alignment: .leading){
//                        Text("Wähle eine Sprache aus".uppercased())
//                            .underline()
//                            .font(.system(size: 14, design: .monospaced))
//                        VStack(alignment: .trailing){
//                            ZStack{
//                                Text(languageVm.emptyField)
//                                Picker("Übersetze nach", selection: $selectionLanguage) {
//                                    ForEach(languageVm.languages, id: \.code) { language in
//                                        Text(language.name)
//                                            .tag(language)
//                                    }
//                                }
//                                .font(.system(size: 17).bold())
//                                .textFieldStyle(.roundedBorder)
//                                .padding(3)
//                                .background(Color.white.opacity(0.8))
//                                .cornerRadius(10)
//                                .frame(minWidth: 310, minHeight: 70)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .stroke(Color.cyan, lineWidth: 2)
//                                )
//                                .pickerStyle(.menu)
//                                .onChange(of: selectionLanguage) { languageVm.languageChoice = selectionLanguage }
//                            }
//                        }
//                    }
//                    Divider()
//                    VStack(alignment: .leading){
//                        Text("Text für die Übersetzung eingeben".uppercased())
//                            .underline()
//                            .font(.system(size: 14, design: .monospaced))
//                        VStack(alignment: .trailing){
//                            ZStack{
//                                if languageVm.textToTranslate.isEmpty {
//                                    Text("Hier Text eingeben")
//                                        .opacity(0.4)
//                                }
//                                TextEditor(text: $languageVm.textToTranslate)
//                                    .font(.system(size: 17).bold())
//                                    .textFieldStyle(.roundedBorder)
//                                    .autocorrectionDisabled()
//                                    .padding(3)
//                                    .frame(width: 310, height: 150)
//                                    .overlay(
//                                        RoundedRectangle(cornerRadius: 10)
//                                            .stroke(Color.cyan, lineWidth: 2)
//                                    )
//                            }
//                            .keyboardType(.default)
//                            .submitLabel(.done)
//                        }
//                    }
//                    Divider()
//                    VStack(alignment: .leading){
//                        Text("Übersetzen von".uppercased())
//                            .underline()
//                            .font(.system(size: 14, design: .monospaced))
//                        HStack{
//                            Text("\(selectionSourceLanguage.name)")
//                                .font(.system(size: 14))
//                                .padding(4)
//                            ButtonTextAction(iconName: "network", text: "Übersetzen"){
//                                languageVm.translateLanguage()
//                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                            }
//                            Text("\(selectionLanguage.name)")
//                                .font(.system(size: 14))
//                                .padding(4)
//                        }
//                        .font(.system(size: 17).bold())
//                        .textFieldStyle(.roundedBorder)
//                        .autocorrectionDisabled()
//                        .textInputAutocapitalization(.never)
//                        .padding(3)
//                        .frame(minWidth: 310, minHeight: 70)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(Color.cyan, lineWidth: 2)
//                        )
//                    }
//                    Divider()
//                    VStack(alignment: .leading){
//                        Text("Ausgabe der Übersetzung".uppercased())
//                            .underline()
//                            .font(.system(size: 14, design: .monospaced))
//                        ZStack{
//                            if languageVm.translatedText.isEmpty {
//                                Text("Übersetzung")
//                                    .opacity(0.4)
//                            }
//                            Text(languageVm.translatedText)
//                                .font(.system(size: 17).bold())
//                                .textFieldStyle(.roundedBorder)
//                                .autocorrectionDisabled()
//                                .textInputAutocapitalization(.never)
//                                .padding(3)
//                                .frame(minWidth: 310, minHeight: 150)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .stroke(Color.red, lineWidth: 2)
//                                )
//                        }
//                    }
//                }
//                Divider()
//            }
//            .scrollContentBackground(.hidden)
//            .background(
//                Image("background")
//                    .resizable()
//                    .scaledToFill()
//                    .opacity(0.2)
//                    .ignoresSafeArea(.all))
//            .navigationBarTitle("Mein Übersetzer", displayMode: .inline)
//            .toolbar{
//                Button("Felder leeren"){
//                    languageVm.clearTextFields()
//                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                }
//            }
//        }
//        .onAppear {
//            languageVm.loadLanguages()
//        }
//        .onDisappear{
//            languageVm.clearTextFields()
//            selectionLanguage = Language(code: "af", name: "Afrikaans")
//        }
//        .background(Color(UIColor.systemBackground))
//    }
//}
//
//#Preview {
//    let languageVm = LanguageScreenViewModel(languageChoice: Language(code: "de", name: "Deutsch"), languageSource: Language(code: "af", name: "Afrikaans"))
//    return LanguageScreenView(languageVm: languageVm)
//}
