//
//  MovieDetailsViewModel.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 24/08/2026.
//

import Foundation

@Observable
class MovieDetailsViewModel {

    private let repo: MovieDetailsRepoProtocol

    var cast: [Cast] = []

    var isLoading = false
    var errorMessage: String?

    init(repo: MovieDetailsRepoProtocol = MovieDetailsRepo(), id: Int) {
        self.repo = repo

        loadMovieDetails(id: id)
    }

    func loadMovieDetails(id: Int)  {
        isLoading = true
        errorMessage = nil
        
        Task {
            
            let minimumLoadingTask = Task {
                try? await Task.sleep(nanoseconds: 1_500_000_000)
            }

            do {
                let castResult = try await repo.fetchMovieCast(id: id)
                cast = castResult.cast
                
            } catch {
                errorMessage = error.localizedDescription
            }

            await minimumLoadingTask.value

            isLoading = false
        }

    }

}
