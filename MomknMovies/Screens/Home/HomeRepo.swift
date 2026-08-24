//
//  HomeRepo.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 23/08/2026.
//

import Foundation

protocol HomeRepoProtocol {
    func fetchPopularMovies() async throws -> MoviesList
    func fetchTopRatedMovies() async throws -> MoviesList
    func fetchUpcomingMovies() async throws -> MoviesList
}

struct HomeRepo: HomeRepoProtocol {

    private let networkService: NetworkManager

    init(networkService: NetworkManager = NetworkManager()) {
        self.networkService = networkService
    }

    func fetchPopularMovies() async throws -> MoviesList {
        let request = try MovieEndpoint.popularMovies.asHTTPRequest()
        return try await networkService.send(request, as: MoviesList.self)
    }

    func fetchTopRatedMovies() async throws -> MoviesList {
        let request = try MovieEndpoint.topRatedMovies.asHTTPRequest()
        return try await networkService.send(request, as: MoviesList.self)
    }

    func fetchUpcomingMovies() async throws -> MoviesList {
        let request = try MovieEndpoint.upcomingMovies.asHTTPRequest()
        return try await networkService.send(request, as: MoviesList.self)
    }
}
