//
//  Movies.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 23/08/2026.
//

import Foundation

struct MoviesList: Codable {
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

struct Movie: Codable {

    let id: Int
    let title: String
    let backdropPath: String
    let genreIDS: [Int]
    let originalTitle: String
    let overview: String
    let posterPath: String
    let releaseDate: String
    let voteAverage: Double
    let voteCount: Int

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
}
