//
//  HorizontalMoviesList.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 22/08/2026.
//

import SwiftUI
import Kingfisher
import SkeletonUI

enum MovieCardStyle {
    case vertical
    case horizontal
    
    func size(for geometry: GeometryProxy) -> CGSize {
        switch self {
        case .vertical:
            return CGSize(width: geometry.size.width * 0.28, height: geometry.size.height * 0.19)
        case .horizontal:
            return CGSize(width: geometry.size.width * 0.65, height: geometry.size.height * 0.17)
        }
    }
}


struct HorizontalMoviesList: View {

    private let skeletonCount = 4

    let title: LocalizedStringKey
    let movies: [Movie]
    let geometry: GeometryProxy
    let isLoading: Bool
    var style: MovieCardStyle = .vertical

    var body: some View {

        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 19, weight: .bold))
                .foregroundColor(.white)
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
                        ForEach(movies, id: \.id) { movie in
                            let size = style.size(for: geometry)

                            KFImage(URL(string: K.posterBaseURL + movie.posterPath))
                                .resizable()
                                .fade(duration: 0.25)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width, height: size.height)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
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

#Preview {
    GeometryReader { geometry in
        VStack {
            HorizontalMoviesList(title: "Popular Movies", movies: [], geometry: geometry, isLoading: false, style: .vertical)
        }
        .background(Color.background)
    }
}
