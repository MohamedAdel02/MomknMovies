//
//  CastRow.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 24/08/2026.
//

import SwiftUI
import Kingfisher
import SkeletonUI

struct CastRow: View {
    
    let cast: [Cast]
    var isLoading: Bool = true

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 15) {
                if isLoading {
                    ForEach(0..<6, id: \.self) { _ in
                        CastCellSkeleton()
                    }
                } else {
                    ForEach(cast, id: \.castID) { member in
                        CastCell(member: member)
                    }
                }
            }
            .padding(.horizontal)
        }
        .scrollDisabled(isLoading)
    }
}

private struct CastCellSkeleton: View {
    var body: some View {
        VStack(spacing: 6) {
            Circle()
                .fill(.white.opacity(0.1))
                .skeleton(with: true,
                          animation: .linear(),
                          appearance: .gradient(color: .white.opacity(0.25), background: .white.opacity(0.08)),
                          shape: .circle)
                .frame(width: 90, height: 90)


            Rectangle()
                .frame(width: 70, height: 12)
                .skeleton(with: true,
                          animation: .linear(),
                          appearance: .gradient(color: .white.opacity(0.25), background: .white.opacity(0.08)),
                          shape: .rounded(.radius(4, style: .continuous)))
        }
    }
}

private struct CastCell: View {
    
    let member: Cast
    
    private var profileURL: URL? {
        guard let path = member.profilePath else { return nil }
        return URL(string: K.imageBaseURL + path)
    }

    var body: some View {
        VStack(spacing: 6) {
            Group {
                if let profileURL {
                    KFImage(profileURL)
                        .placeholder {
                            Circle()
                                .fill(.white.opacity(0.1))
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Circle()
                        .fill(.white.opacity(0.1))
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(.white.opacity(0.4))
                        )
                }
            }
            .frame(width: 90, height: 90)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(.white.opacity(0.2), lineWidth: 1)
            )

            Text(member.name)
                .font(.footnote.weight(.medium))
                .foregroundStyle(.white.opacity(0.8))
                .lineLimit(2)
                .frame(width: 90)
                .multilineTextAlignment(.center)
        }
    }

}
