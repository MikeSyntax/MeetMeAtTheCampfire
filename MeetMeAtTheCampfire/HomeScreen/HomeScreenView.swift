//
//  HomeScreenView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 04.03.24.
//

import SwiftUI

struct HomeScreenView: View {
    @StateObject private var homeVm = HomeScreenViewModel()
    @StateObject private var detailCategorieVm = DetailCategorieViewModel()
    @StateObject private var detailCategorieItemVm = DetailCategorieItemViewModel(detailCategorieItemModel: TaskModel(categorieId: "1", taskName: "1", taskIsDone: false))
    
    @State private var showNewCategorieAlert = false
    @State private var newCategorie = ""
    @State private var showSettingsSheet: Bool = false
    @State private var showAnimation: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Divider()
                VStack{
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 3), spacing: 20) {
                            ForEach(homeVm.categorieViewModels) { categorieViewModel in
                                NavigationLink(destination: DetailCategorieView(categorieVm: categorieViewModel, homeVm: homeVm, detailCategorieVm: detailCategorieVm, detailCategorieItemVm: detailCategorieItemVm)) {
                                    CategorieFilledView(categorieVm: categorieViewModel, detailCategorieVm: detailCategorieVm)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.vertical, 20)
                }
                VStack{
                    ZStack{
                        if homeVm.categorieViewModels.isEmpty {
                            ZStack{
                                CircularTextView(title: "   Deine Camper App -Meet me at the campfire".uppercased(), radius: 125)
                                if SettingsScreenView().isDark {
                                    Image(.logo)
                                        .resizable()
                                        .frame(width: 150, height: 150)
                                        .clipShape(Circle())
                                        .opacity(0.6)
                                } else {
                                    Image(.logo)
                                        .resizable()
                                        .frame(width: 150, height: 150)
                                        .clipShape(Circle())
                                }
                            }
                            .offset(x: 0, y: -300)
                        }
                        VStack{
                            if homeVm.categorieViewModels.isEmpty {
                                HStack(){
                                    VideoStartCategoriesView()
                                        .opacity(0.6)
                                }
                            }
                        }
                        .frame(width: 300)
                        .cornerRadius(30)
                    }
                    if !homeVm.categorieViewModels.isEmpty && homeVm.categorieViewModels[0].tasksInCategorie == 0  {
                        HStack(){
                            VideoStartToDosView()
                                .opacity(0.6)
                        }
                        .frame(width: 300)
                        .cornerRadius(30)
                        .offset(x: 0, y: -100)
                    }
                }
                Divider()
                Button(action: {
                    showNewCategorieAlert.toggle()
                }, label: {
                    CategorieAddView()
                })
                .transition(.move(edge: .top))
                .animation(.default, value: showAnimation)
                //.padding(.bottom)
                Divider()
            }
            .preferredColorScheme(SettingsScreenView().isDark ? .dark : .light)
            .toolbar{
                Button {
                    showSettingsSheet.toggle()
                } label: {
                    //Text("Einstellungen")
                    Image(systemName: "gearshape")
                }
            }
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
                    .ignoresSafeArea(.all))
            .navigationBarTitle("Meine Kategorien", displayMode: .inline)
        }
        .alert("Neue Kategorie", isPresented: $showNewCategorieAlert) {
            if SettingsScreenView().isDark {
                TextField("Name", text: $newCategorie)
                    .lineLimit(1)
                    .foregroundColor(.black)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                Button("Zurück") {
                    dismiss()
                }
                Button("Speichern") {
                    homeVm.createCategorie(categorieName: newCategorie)
                    newCategorie = ""
                }
            } else {
                TextField("Name", text: $newCategorie)
                    .lineLimit(1)
                    .foregroundColor(.black)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                Button("Zurück") {
                    dismiss()
                }
                Button("Speichern") {
                    homeVm.createCategorie(categorieName: newCategorie)
                    newCategorie = ""
                }
            }
        }
        .sheet(isPresented: $showSettingsSheet) {
            SettingsScreenView()
        }
        .onAppear {
            homeVm.readCategories()
            showAnimation = true
        }
        .onDisappear{
            homeVm.removeListener()
        }
    }
}


#Preview {
    HomeScreenView()
}
