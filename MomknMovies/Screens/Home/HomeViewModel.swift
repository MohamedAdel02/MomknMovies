//
//  HomeViewModel.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 21/08/2026.
//

import Foundation

@Observable
class HomeViewModel {

    private let repo: HomeRepoProtocol

    var popularMovies: [Movie] = []
    var topRatedMovies: [Movie] = []
    var upcomingMovies: [Movie] = []

    var isLoading = false
    var errorMessage: String?

    init(repo: HomeRepoProtocol = HomeRepo()) {
        self.repo = repo
        
        Task {
            await loadHomeData()
        }
    }

    func loadHomeData() async {
        
        isLoading = true
        errorMessage = nil


        let minimumLoadingTask = Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
        }
        
        async let popular = repo.fetchPopularMovies()
        async let topRated = repo.fetchTopRatedMovies()
        async let upcoming = repo.fetchUpcomingMovies()
        

        do {
            let (popularResult, topRatedResult, upcomingResult) = try await (popular, topRated, upcoming)
            popularMovies = popularResult.movie
            topRatedMovies = topRatedResult.movie
            upcomingMovies = upcomingResult.movie
        } catch {
            errorMessage = error.localizedDescription
        }
        
        await minimumLoadingTask.value
        
        isLoading = false
    }
    
}
