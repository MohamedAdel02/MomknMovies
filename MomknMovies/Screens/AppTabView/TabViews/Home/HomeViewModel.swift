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
    var moviesGenres: [Genre] = []
    
    private var popularPage = 1
    private var topRatedPage = 1
    private var upcomingPage = 1
    var isFetchingNextPage = false
    
    var isLoading = true
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
                
        async let popularTask = getPopularMovies(page: 1)
        async let topRatedTask = getTopRatedMovies(page: 1)
        async let upcomingTask = getUpcomingMovies(page: 1)
        async let genresTask = getGenres()

        _ = await (popularTask, topRatedTask, upcomingTask, genresTask)

        await minimumLoadingTask.value
        
        
        isLoading = false
    }
    
    
    func getPopularMovies(page: Int) async {
        do {
            let result = try await repo.fetchPopularMovies(page: page)
            popularMovies.append(contentsOf: result.movie)
        } catch {
            errorMessage = error.localizedDescription
        }
    }


    func getTopRatedMovies(page: Int) async {
        do {
            let result = try await repo.fetchTopRatedMovies(page: page)
            topRatedMovies.append(contentsOf: result.movie)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func getUpcomingMovies(page: Int) async {
        do {
            let result = try await repo.fetchUpcomingMovies(page: page)
            upcomingMovies.append(contentsOf: result.movie)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func getGenres() async {
        do {
            let result = try await repo.fetchGenres()
            moviesGenres = result.genres
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    
    func loadNextPageIfNeeded(category: MovieListCategory, currentItem movie: Movie) async {
        let movies = movies(for: category)

        guard let index = movies.firstIndex(where: { $0.id == movie.id }) else { return }
        guard index >= movies.count - 3 else { return }
        guard !isFetchingNextPage else { return }

        isFetchingNextPage = true
        
        // defer executes right before the function returns
        defer { isFetchingNextPage = false }

        switch category {
        case .popular:
            popularPage += 1
            do {
                let result = try await repo.fetchPopularMovies(page: popularPage)
                popularMovies.append(contentsOf: result.movie)
            } catch {
                popularPage -= 1
                errorMessage = error.localizedDescription
            }

        case .topRated:
            topRatedPage += 1
            do {
                let result = try await repo.fetchTopRatedMovies(page: topRatedPage)
                topRatedMovies.append(contentsOf: result.movie)
            } catch {
                topRatedPage -= 1
                errorMessage = error.localizedDescription
            }

        case .commingSoon:
            upcomingPage += 1
            do {
                let result = try await repo.fetchUpcomingMovies(page: upcomingPage)
                upcomingMovies.append(contentsOf: result.movie)
            } catch {
                upcomingPage -= 1
                errorMessage = error.localizedDescription
            }
        }
    }
    
    private func movies(for category: MovieListCategory) -> [Movie] {
        switch category {
        case .popular: return popularMovies
        case .topRated: return topRatedMovies
        case .commingSoon: return upcomingMovies
        }
    }
    
}
