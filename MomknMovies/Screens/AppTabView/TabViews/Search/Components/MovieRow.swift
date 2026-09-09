//
//  MovieRow.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 26/08/2026.
//

import SwiftUI
import Kingfisher

struct MovieRow: View {
    
    let movie: Movie

    var body: some View {
        HStack(spacing: 12) {
            KFImage(URL(string: K.posterBaseURL + movie.posterPath))
                .placeholder {
                    if movie.posterPath.isEmpty {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(.secondary.opacity(0.2))
                            .overlay {
                                Image(systemName: "film")
                                    .foregroundStyle(.white.opacity(0.8))
                            }
                    } else {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(.secondary.opacity(0.2))
                            .addSkelton()
                    }
                }
                .onFailure { _ in }
                .fade(duration: 0.25)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 56, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.9))
                    .lineLimit(2)

                Text("Movie")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
            }
            
            Spacer()
        }
        .padding(10)
        .background(Color.customGray.opacity(0.12), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

#Preview {
    MovieRow(movie: Movie.mockSpiderMan)
}
