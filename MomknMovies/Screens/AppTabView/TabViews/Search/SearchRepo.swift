//
//  SearchRepo.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 26/08/2026.
//

import SwiftUI

protocol SearchRepoProtocol {
    func getSearchResult(query: String) async throws -> [Movie]
}

struct SearchRepo: SearchRepoProtocol {

    private let networkService: NetworkManager

    init(networkService: NetworkManager = NetworkManager()) {
        self.networkService = networkService
    }

    func getSearchResult(query: String) async throws -> [Movie] {
        let request = try MovieEndpoint.search(query).asHTTPRequest()
        return try await networkService.send(request, as: MoviesList.self).movie
    }

}
