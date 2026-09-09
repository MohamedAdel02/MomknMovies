//
//  AllMoviesView.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 04/09/2026.
//

import SwiftUI

struct AllMoviesView: View {

    let category: MovieListCategory

    @Environment(Router<MainRoute>.self) private var router
    @Environment(HomeViewModel.self) private var viewModel

    private var movies: [Movie] {
        switch category {
        case .popular: return viewModel.popularMovies
        case .topRated: return viewModel.topRatedMovies
        case .commingSoon: return viewModel.upcomingMovies
        }
    }

    var body: some View {
        ZStack {
            background()

            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(movies, id: \.self) { movie in
                        MovieRow(movie: movie)
                            .padding(.horizontal)
                            .onTapGesture {
                                router.push(.movieDetails(movie: movie))
                            }
                            .task {
                                await viewModel.loadNextPageIfNeeded(category: category, currentItem: movie)
                            }
                    }
                    
                    if viewModel.isFetchingNextPage {
                        ProgressView()
                            .tint(.white.opacity(0.8))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                    }
                    
                }
                .padding(.top, 12)
                .padding(.bottom, 40)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle(category.title)
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
    AllMoviesView(category: .popular)
        .environment(HomeViewModel())
        .environment(Router<MainRoute>())
}
