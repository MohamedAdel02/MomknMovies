//
//  Movies.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 23/08/2026.
//

import Foundation
import SwiftData

struct MoviesList: Codable, Hashable {
    
    let page: Int
    let movie: [Movie]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case movie = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Codable, Hashable {

    var id: Int
    var title: String
    var backdropPath: String
    var genreIDS: [Int]
    var originalTitle: String
    var overview: String
    var posterPath: String
    var releaseDate: String
    var voteAverage: Double
    var voteCount: Int

    init(
        id: Int,
        title: String,
        backdropPath: String = "",
        genreIDS: [Int],
        originalTitle: String,
        overview: String,
        posterPath: String = "",
        releaseDate: String,
        voteAverage: Double,
        voteCount: Int
    ) {
        self.id = id
        self.title = title
        self.backdropPath = backdropPath
        self.genreIDS = genreIDS
        self.originalTitle = originalTitle
        self.overview = overview
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case originalTitle = "original_title"
        case overview = "overview"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? "Untitled"
        backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath) ?? ""
        genreIDS = try container.decodeIfPresent([Int].self, forKey: .genreIDS) ?? []
        originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle) ?? ""
        overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? ""
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath) ?? ""
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
        voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage) ?? 0
        voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount) ?? 0
    }
}
