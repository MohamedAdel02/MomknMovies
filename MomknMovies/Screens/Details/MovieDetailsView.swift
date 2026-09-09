//
//  MovieDetailsView.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 24/08/2026.
//

import SwiftUI
import SwiftData
import Kingfisher
import FirebaseAuth

enum ImageLoadState {
    case loading
    case loaded
    case error
}

struct MovieDetailsView: View {

    @State private var posterLoadState: ImageLoadState = .loading
    @State private var viewModel: MovieDetailsViewModel
    
    @Environment(AppTabViewModel.self) private var appTabViewModel
    @Environment(\.modelContext) private var modelContext
    @Query private var favoriteMovies: [FavoriteMovies]

    private var isFavorite: Bool {
        favoriteMovies.first?.movieIDs.contains(movie.id) ?? false
    }
    
    let movie: Movie

    private var genreNames: [String] {
        movie.genreIDS.compactMap { id in
            appTabViewModel.moviesGenres.first(where: { $0.id == id })?.name
        }
    }

    init(movie: Movie) {
        self.movie = movie
        _viewModel = State(initialValue: MovieDetailsViewModel(id: movie.id))
        
        let userID = Auth.auth().currentUser?.uid ?? ""
        _favoriteMovies = Query(filter: #Predicate<FavoriteMovies> { $0.userID == userID })
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {

                background(geometry)

                VStack(spacing: 0) {

                    ScrollView {
                        VStack(alignment: .leading) {

                            if movie.backdropPath.isEmpty {

                                Spacer(minLength: 120)
                            } else {
                                
                                backDropImage(geometry: geometry)
                            }


                            HStack(alignment: .top, spacing: 15) {

                                moviePoster(geometry: geometry)

                                VStack(alignment: .leading) {

                                    Text(movie.title)
                                        .addSkelton(viewModel.isLoading)
                                        .frame(height: viewModel.isLoading ? 10 : nil)
                                        .foregroundStyle(.white)
                                        .font(.system(size: 24))
                                        .bold()
                                        .padding(.top)


                                    genresView()
                                }

                                Spacer()

                            }
                            .padding(.horizontal)

                            Text(movie.overview)
                                .addSkelton(viewModel.isLoading)
                                .frame(height: viewModel.isLoading ? 80 : nil)
                                .foregroundStyle(.white)
                                .font(.system(size: 16, weight: .medium))
                                .padding(.horizontal)
                                .padding(.top)
                                .padding(.bottom)

                            if !viewModel.cast.isEmpty {
                                Text("Cast")
                                    .addSkelton(viewModel.isLoading)
                                    .foregroundStyle(.white.opacity(0.9))
                                    .padding(.horizontal)
                                    .font(.title2.weight(.semibold))
                            }


                            CastRow(cast: viewModel.cast, isLoading: viewModel.isLoading)
                                .padding(.bottom, 30)
                        }

                    }
                    .scrollIndicators(.hidden)

                    ratingView(geometry: geometry)
                        .ignoresSafeArea()

                }
            }
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        toggleFavorite()
                    } label: {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundStyle(isFavorite ? .red : .white)
                    }
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


    func backDropImage(geometry: GeometryProxy) -> some View {

        ZStack(alignment: .bottom) {

            KFImage(URL(string: K.posterBaseURL + movie.backdropPath))
                .resizable()
                .fade(duration: 0.25)
                .aspectRatio(contentMode: .fill)
                .addSkelton(viewModel.isLoading)
                .frame(width: geometry.size.width, height: geometry.size.height * 0.35)

            LinearGradient(
                colors: [.background.opacity(0.1), .background.opacity(0.9)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(width: geometry.size.width, height: geometry.size.height * 0.1)

        }
        .frame(width: geometry.size.width, height: geometry.size.height * 0.35)
    }


    func moviePoster(geometry: GeometryProxy) -> some View {
        ZStack {
            KFImage(URL(string: K.posterBaseURL + movie.posterPath))
                .onSuccess { _ in posterLoadState = .loaded }
                .onFailure { _ in posterLoadState = .error }
                .resizable()
                .fade(duration: 0.25)
                .aspectRatio(contentMode: .fill)
                .addSkelton(viewModel.isLoading)
                .opacity(posterLoadState == .loaded ? 1 : 0)

            if posterLoadState == .loading {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .addSkelton(true)
            } else if posterLoadState == .error {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.15))
                    .overlay(
                        VStack(spacing: 6) {
                            Image(systemName: "film")
                                .font(.title)
                                .foregroundColor(.gray)

                    })
            }
        }
        .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.25)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.top,movie.backdropPath.isEmpty ? 10 : -80)
    }

    func genresView() -> some View {

        FlowLayout(spacing: 8) {
            ForEach(genreNames, id: \.self) { name in

                Text(name)
                    .addSkelton(viewModel.isLoading)
                    .frame(width : viewModel.isLoading ? 50 : nil)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.white.opacity(0.1))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().stroke(.white.opacity(0.4), lineWidth: 1)
                    )

            }
        }
    }

    func ratingView(geometry: GeometryProxy) -> some View {

        ZStack(alignment: .center) {

            LinearGradient(
                colors: [.background2.opacity(0.5), .background2.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .addSkelton(viewModel.isLoading)
            .frame(
                width: geometry.size.width,
                height: geometry.size.height * 0.08,
            )
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .ignoresSafeArea()

            if !viewModel.isLoading {

                StarRatingView(voteAverage: movie.voteAverage)
            }
        }

    }
    
    
    private func toggleFavorite() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        if let existing = favoriteMovies.first(where: { $0.userID == userID }) {
            if let index = existing.movieIDs.firstIndex(of: movie.id) {
                existing.movieIDs.remove(at: index)
            } else {
                existing.movieIDs.append(movie.id)
            }
        } else {
            modelContext.insert(FavoriteMovies(userID: userID, movieIDs: [movie.id]))
        }
        
        try? modelContext.save()
    }

}


#Preview {
    MovieDetailsView(movie: Movie.mockSpiderMan)
}
