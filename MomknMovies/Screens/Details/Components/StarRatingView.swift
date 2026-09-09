//
//  StarRatingView.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 24/08/2026.
//

import SwiftUI

struct StarRatingView: View {
    
    let voteAverage: Double
    
    private var ratingOutOfFive: Double {
        voteAverage / 2
    }
    
    private var truncatedRating: String {
        let truncated = (ratingOutOfFive * 10).rounded(.towardZero) / 10
        return String(format: "%.1f", truncated)
    }

    var body: some View {
        HStack(spacing: 20) {
            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { index in
                    starImage(for: index)
                        .foregroundStyle(.yellow)
                        .font(.headline)
                }
            }

            Text(truncatedRating)
                .font(.title2.weight(.bold))
                .foregroundStyle(.white.opacity(0.7))
        }
        
    }

    private func starImage(for index: Int) -> Image {
        let filledThreshold = Double(index) - 0.5

        if ratingOutOfFive >= Double(index) {
            return Image(systemName: "star.fill")
        } else if ratingOutOfFive >= filledThreshold {
            return Image(systemName: "star.leadinghalf.filled")
        } else {
            return Image(systemName: "star")
        }
    }
    
}

#Preview {
    StarRatingView(voteAverage: 7.6)
}
