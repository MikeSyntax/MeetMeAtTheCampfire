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
    @State private var showAnimation: Bool = false
    @State private var showNewCategorieAlert: Bool = false
    @State private var newCategorie: String = ""
    @State private var showSettingsSheet: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    //@AppStorage("isDarkMode") var isDark: Bool = false
    
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
//                                if isDark {
//                                    Image(.logo)
//                                        .resizable()
//                                        .frame(width: 150, height: 150)
//                                        .clipShape(Circle())
//                                        .opacity(0.7)
//                                } else {
                                    Image(.logo)
                                        .resizable()
                                        .frame(width: 150, height: 150)
                                        .clipShape(Circle())
                                        .opacity(0.7)
//                                }
                            }
                            .offset(x: 0, y: -300)
                        }
                        VStack{
                            if homeVm.categorieViewModels.isEmpty {
                                VideoStartCategoriesView()
                                    .opacity(0.7)
                                    .frame(width: 300)
                            }
                        }
                    }
                    VStack{
                        if !homeVm.categorieViewModels.isEmpty && homeVm.categorieViewModels[0].tasksInCategorie == 0  {
                            HStack(){
                                VideoStartToDosView()
                                    .opacity(0.7)
                                    .frame(width: 300)
                                    .offset(x: 0, y: -100)
                            }
                        }
                    }
                }
                Button{
                    showNewCategorieAlert.toggle()
                }label: {
                    CategorieAddView()
                }
                .animation(Animation.smooth(duration: 0.9, extraBounce: 0.6), value: showAnimation)
                .onAppear {
                    showAnimation = true
                }
                Divider()
            }
            .toolbar{
                Button {
                    showSettingsSheet.toggle()
                } label: {
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
                TextField("Name", text: $newCategorie)
                    .lineLimit(1)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                Button("Zurück") {
                    newCategorie = ""
                    dismiss()
                }
                Button("Speichern") {
                    homeVm.createCategorie(categorieName: newCategorie)
                    newCategorie = ""
                }
        }
        .sheet(isPresented: $showSettingsSheet) {
            SettingsScreenView()
        }
        .onAppear {
            homeVm.readCategories()
        }
        .onDisappear{
            homeVm.removeListener()
            showAnimation = false
        }
        .background(Color(UIColor.systemBackground))
    }
}

#Preview {
    HomeScreenView()
}
