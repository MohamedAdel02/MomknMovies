//
//  AppTabView.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 22/08/2026.
//

import SwiftUI
import SwiftData

struct AppTabView: View {
    
    @Binding var selectedTab: Int
    let userID: String
    
    @State private var homeRouter = Router<MainRoute>()
    @State private var searchRouter = Router<MainRoute>()
    @State private var profileRouter = Router<ProfileRoute>()
    
    @State private var viewModel = AppTabViewModel()
    @State private var homeViewModel = HomeViewModel()
    @Query private var favoriteMovies: [FavoriteMovies]
    
    init(selectedTab: Binding<Int>, userID: String) {
        self._selectedTab = selectedTab
        self.userID = userID
        self._favoriteMovies = Query(filter: #Predicate<FavoriteMovies> { $0.userID == userID })
    }
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            Tab("Home", systemImage: "house", value: 0) {
                NavigationStack(path: $homeRouter.path) {
                    HomeView()
                }
                .environment(homeRouter)
                .environment(homeViewModel)
            }
            
            Tab("Search", systemImage: "magnifyingglass", value: 1) {
                NavigationStack(path: $searchRouter.path) {
                    SearchView()
                }
                .environment(searchRouter)
                .environment(homeViewModel)
            }
            
            Tab("Profile", systemImage: "person", value: 2) {
                NavigationStack(path: $profileRouter.path) {
                    ProfileView()
                }
                .environment(profileRouter)
            }
                    
        }
        .tint(Color.buttonGradient2)
        .environment(viewModel)
        .task {
            await viewModel.loadFavorites(ids: favoriteMovies.first?.movieIDs ?? [])
        }
        .onChange(of: favoriteMovies.first?.movieIDs) { _, newValue in
            Task {
                await viewModel.loadFavorites(ids: newValue ?? [])
            }
        }
    }
}

//#Preview {
//    AppTabView()
//}
