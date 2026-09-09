//
//  AppTabRepo.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 28/08/2026.
//

import Foundation

protocol AppTabRepoProtocol {
    func fetchGenres() async throws -> GenreResponse
    func fetchMovieDetails(id: Int) async throws -> Movie
}

struct AppTabRepo: AppTabRepoProtocol {

    private let networkService: NetworkManager

    init(networkService: NetworkManager = NetworkManager()) {
        self.networkService = networkService
    }

    func fetchGenres() async throws -> GenreResponse {
        let request = try MovieEndpoint.genres.asHTTPRequest()
        return try await networkService.send(request, as: GenreResponse.self)
    }
    
    func fetchMovieDetails(id: Int) async throws -> Movie {
        let request = try MovieEndpoint.movieDetails(id: id).asHTTPRequest()
        return try await networkService.send(request, as: Movie.self)
    }
}
