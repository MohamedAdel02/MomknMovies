//
//  MovieDetailsRepo.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 24/08/2026.
//

import Foundation

protocol MovieDetailsRepoProtocol {
    func fetchMovieCast(id: Int) async throws -> CastResult
}

struct MovieDetailsRepo: MovieDetailsRepoProtocol {

    private let networkService: NetworkManager

    init(networkService: NetworkManager = NetworkManager()) {
        self.networkService = networkService
    }

    func fetchMovieCast(id: Int) async throws -> CastResult {
        let request = try MovieEndpoint.movieCast(id: id).asHTTPRequest()
        return try await networkService.send(request, as: CastResult.self)
    }
}

