//
//  HomeView.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 21/08/2026.
//

import SwiftUI

struct HomeView: View {

    @State private var viewModel = HomeViewModel()

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

                            
                            HorizontalMoviesList(title: "Popular Movies", movies: viewModel.popularMovies, geometry: geometry, isLoading: viewModel.isLoading)

                            HorizontalMoviesList(title: "Top Rated", movies: viewModel.topRatedMovies, geometry: geometry, isLoading: viewModel.isLoading)

                            HorizontalMoviesList(title: "Upcoming", movies: viewModel.upcomingMovies, geometry: geometry, isLoading: viewModel.isLoading)
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
}

#Preview {
    HomeView()
}
