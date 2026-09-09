//
//  Genre.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 24/08/2026.
//

import Foundation

struct GenreResponse: Codable, Hashable {
    let genres: [Genre]
}

struct Genre: Codable, Hashable {
    let id: Int
    let name: String
}
