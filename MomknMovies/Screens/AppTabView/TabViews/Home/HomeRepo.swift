//
//  HomeRepo.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 23/08/2026.
//

import Foundation

protocol HomeRepoProtocol {
    func fetchPopularMovies(page: Int) async throws -> MoviesList
    func fetchTopRatedMovies(page: Int) async throws -> MoviesList
    func fetchUpcomingMovies(page: Int) async throws -> MoviesList
    func fetchGenres() async throws -> GenreResponse
}

struct HomeRepo: HomeRepoProtocol {

    private let networkService: NetworkManager

    init(networkService: NetworkManager = NetworkManager()) {
        self.networkService = networkService
    }

    func fetchPopularMovies(page: Int) async throws -> MoviesList {
        print(page)
        let request = try MovieEndpoint.popularMovies(page: page ).asHTTPRequest()
        return try await networkService.send(request, as: MoviesList.self)
    }

    func fetchTopRatedMovies(page: Int) async throws -> MoviesList {
        print(page)
        let request = try MovieEndpoint.topRatedMovies(page: page).asHTTPRequest()
        return try await networkService.send(request, as: MoviesList.self)
    }

    func fetchUpcomingMovies(page: Int) async throws -> MoviesList {
        print(page)
        let request = try MovieEndpoint.upcomingMovies(page: page).asHTTPRequest()
        return try await networkService.send(request, as: MoviesList.self)
    }

    func fetchGenres() async throws -> GenreResponse {
        let request = try MovieEndpoint.genres.asHTTPRequest()
        return try await networkService.send(request, as: GenreResponse.self)
    }
}
