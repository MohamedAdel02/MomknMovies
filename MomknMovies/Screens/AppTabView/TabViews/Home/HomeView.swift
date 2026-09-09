//
//  HomeView.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 21/08/2026.
//

import SwiftUI

struct HomeView: View {

    @Environment(HomeViewModel.self) private var viewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                background(geometry)

                VStack(spacing: 0) {
                    NavigationView(geometry: geometry)

                    ScrollView {
                        VStack(spacing: 20) {
                            
                            BannerView(isLoading: viewModel.isLoading)
                                .frame(width: geometry.size.width, height: geometry.size.height * 0.23)

                            
                            HorizontalMoviesList(category: .popular, movies: viewModel.popularMovies, genres: viewModel.moviesGenres, geometry: geometry, isLoading: viewModel.isLoading)

                            HorizontalMoviesList(category: .topRated, movies: viewModel.topRatedMovies, genres: viewModel.moviesGenres, geometry: geometry, isLoading: viewModel.isLoading)

                            HorizontalMoviesList(category: .commingSoon, movies: viewModel.upcomingMovies, genres: viewModel.moviesGenres, geometry: geometry, isLoading: viewModel.isLoading)
                        }
                        .padding(.top, 30)
                        .padding(.bottom, 80)
                    }
                    .scrollIndicators(.hidden)

                    Spacer()
                }
            }
        }
        .ignoresSafeArea()
        .navigationDestination(for: MainRoute.self) { route in
            destinationView(for: route)
        }

    }

    func background(_ geometry: GeometryProxy) -> some View {
        LinearGradient(
            colors: [.background2, .background],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .frame(width: geometry.size.width, height: geometry.size.height)
        .ignoresSafeArea()
    }
    
    
    @ViewBuilder
    private func destinationView(for route: MainRoute) -> some View {
        switch route {
        case .movieDetails(let movie):
            MovieDetailsView(movie: movie)
        case .allMovies(let category):
            AllMoviesView(category: category)
        }
    }

}

#Preview {
    HomeView()
        .environment(HomeViewModel())
}
