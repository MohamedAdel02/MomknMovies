//
//  MockData.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 24/08/2026.
//

import Foundation

extension Movie {
    static let mockOdyssey = Movie(
        id: 1368337,
        title: "The Odyssey",
        backdropPath: "/RMXG8myu1aGlNUsRjtxzmpdMK0.jpg",
        genreIDS: [12, 28, 14],
        originalTitle: "The Odyssey",
        overview: "Odysseus, the legendary King of Ithaca, embarks on a long and perilous journey home following the Trojan War. Throughout his voyage, he is forced to confront the whims of gods, mythological monsters, and trials that stretch both his cunning and his humanity to the breaking point.",
        posterPath: "/5rhTDKUhPYvpdQIijFIs5VoWsON.jpg",
        releaseDate: "2026-07-15",
        voteAverage: 7.999,
        voteCount: 3122
    )

    static let mockSpiderMan = Movie(
        id: 969681,
        title: "Spider-Man: Brand New Day",
        backdropPath: "/7iwUUcKURMT7aKfCwMy6YnGtchD.jpg",
        genreIDS: [878, 28, 12],
        originalTitle: "Spider-Man: Brand New Day",
        overview: "Fighting crime full-time as Spider-Man in a world that doesn't remember him—and the pressure of seeing his old friends move on without him—sparks a change in Peter Parker he may not have the power to control. But that transformation might also be the only thing that can stop a shocking new threat to the city and those he loves - a powerful villain no one can even see.",
        posterPath: "/tV712n7bMaRuaKyltFl65HPNRiP.jpg",
        releaseDate: "2026-07-29",
        voteAverage: 7.9,
        voteCount: 2098
    )

    static let mock = mockOdyssey
    static let mockArray: [Movie] = [.mockOdyssey, .mockSpiderMan]
}

extension MoviesList {
    static let mock = MoviesList(
        page: 1,
        movie: Movie.mockArray,
        totalPages: 1,
        totalResults: Movie.mockArray.count
    )
}


extension Genre {
    static let mockList: [Genre] = [
        Genre(id: 28, name: "Action"),
        Genre(id: 12, name: "Adventure"),
        Genre(id: 16, name: "Animation"),
        Genre(id: 35, name: "Comedy"),
        Genre(id: 80, name: "Crime"),
        Genre(id: 99, name: "Documentary"),
        Genre(id: 18, name: "Drama"),
        Genre(id: 10751, name: "Family"),
        Genre(id: 14, name: "Fantasy"),
        Genre(id: 36, name: "History"),
        Genre(id: 27, name: "Horror"),
        Genre(id: 10402, name: "Music"),
        Genre(id: 9648, name: "Mystery"),
        Genre(id: 10749, name: "Romance"),
        Genre(id: 878, name: "Science Fiction"),
        Genre(id: 10770, name: "TV Movie"),
        Genre(id: 53, name: "Thriller"),
        Genre(id: 10752, name: "War"),
        Genre(id: 37, name: "Western")
    ]

    static let dictionary: [Int: String] = Dictionary(
        uniqueKeysWithValues: mockList.map { ($0.id, $0.name) }
    )
}
