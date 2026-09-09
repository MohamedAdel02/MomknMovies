//
//  HorizontalMoviesList.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 22/08/2026.
//

import SwiftUI
import Kingfisher
import SkeletonUI

struct HorizontalMoviesList: View {

    private let skeletonCount = 4

    let category: MovieListCategory
    let movies: [Movie]
    let genres: [Genre]
    let geometry: GeometryProxy
    let isLoading: Bool
    var style: MovieCardStyle = .vertical

    @AppStorage("selectedLanguage") private var selectedLanguage: String?
    @Environment(Router<MainRoute>.self) private var router

    var body: some View {

        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                Text(category.title)
                    .font(.system(size: 19, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button {
                    router.push(.allMovies(category: category))
                } label: {
                    HStack(spacing: 5) {
                        Text("See All")
                        Image(systemName: selectedLanguage == "ar" ? "chevron.left" : "chevron.right")                              .font(.caption2.weight(.semibold))
                    }
                    .font(.subheadline)
                    .foregroundStyle(.blue.opacity(0.9))
                }
                
            }
            .padding(.horizontal)


            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    if isLoading {
                        ForEach(0..<skeletonCount, id: \.self) { _ in
                            let size = style.size(for: geometry)

                            skeltonPlaceholder()
                                .frame(width: size.width, height: size.height)
                        }
                    } else {
                        ForEach(movies.prefix(20), id: \.id) { movie in
                            let size = style.size(for: geometry)

                            KFImage(URL(string: K.posterBaseURL + movie.posterPath))
                                .resizable()
                                .placeholder {
                                    skeltonPlaceholder()
                                        .frame(width: size.width, height: size.height)
                                }
                                .fade(duration: 0.25)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width, height: size.height)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    router.push(.movieDetails(movie: movie))
                                }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private func skeltonPlaceholder() -> some View {
        Rectangle()
            .fill(Color.clear)
            .skeleton(with: true,
                      animation: .linear(),
                      appearance: .gradient(color: .white.opacity(0.25), background: .white.opacity(0.08)),
                      shape: .rounded(.radius(12, style: .continuous)))
    }
}
