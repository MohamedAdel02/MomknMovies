//
//  AllFavoritesView.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 31/08/2026.
//

import SwiftUI

struct AllFavoritesView: View {
    
    @Environment(AppTabViewModel.self) private var appTabViewModel
    @Environment(Router<ProfileRoute>.self) private var router
    
    var body: some View {
        ZStack {
            background()
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(appTabViewModel.favoriteMovies, id: \.self) { movie in
                        MovieRow(movie: movie)
                            .padding(.horizontal)
                            .onTapGesture {
                                router.push(.movieDetails(movie: movie))
                            }
                    }
                }
                .padding(.top, 12)
                .padding(.bottom, 40)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Favorites")
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
    
    private func background() -> some View {
        LinearGradient(
            colors: [.background2, .background],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

#Preview {
    AllFavoritesView()
}
