//
//  FavoritesView.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 28/08/2026.
//

import SwiftUI
import SwiftData
import Kingfisher

struct FavoritesView: View {
    
    var favorites: [Movie]
    let geometry: GeometryProxy
    @AppStorage("selectedLanguage") private var selectedLanguage: String?
    @Environment(Router<ProfileRoute>.self) private var router
    
    private var displayedFavorites: [Movie] {
        Array(favorites.prefix(5))
    }
    
    private var hasMoreFavorites: Bool {
        favorites.count > 5
    }

    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            HStack {
                Text("Favorites")
                    .font(.headline)
                    .foregroundStyle(.white)
                
                Spacer()
                
                if hasMoreFavorites {
                    Button {
                        router.push(.allFavorites)
                    } label: {
                        HStack(spacing: 5) {
                            Text("See All")
                            Image(systemName: selectedLanguage == "ar" ? "chevron.left" : "chevron.right")                                .font(.caption2.weight(.semibold))
                            
                        }
                        .font(.subheadline)
                        .foregroundStyle(.blue.opacity(0.8))
                    }
                }
            }
            .padding(.horizontal)

            
            if favorites.isEmpty {
                emptyState()
                    .padding(.horizontal)

            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(displayedFavorites, id: \.id) { movie in
                            posterView(movie: movie, geometry: geometry)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    
    private func emptyState() -> some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(.customGray.opacity(0.1))
            .frame(height: 150)
            .overlay {
                VStack(spacing: 8) {
                    Image(systemName: "film")
                        .font(.title)
                        .foregroundStyle(Color.customGray.opacity(0.8))
                    Text("No favorites yet")
                        .font(.subheadline)
                        .foregroundStyle(Color.customGray.opacity(0.8))
                }
            }
    }
    
    
    private func posterView(movie: Movie, geometry: GeometryProxy) -> some View {

        KFImage(URL(string: K.posterBaseURL + movie.posterPath))
            .resizable()
            .fade(duration: 0.25)
            .aspectRatio(contentMode: .fill)
            .frame(width: geometry.size.width * 0.28, height: geometry.size.height * 0.22)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .contentShape(Rectangle())
            .onTapGesture {
                router.push(.movieDetails(movie: movie))
            }
    }

}

//#Preview {
//    FavoritesView()
//}
