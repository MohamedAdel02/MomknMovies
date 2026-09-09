import Foundation
import SwiftData

@Observable
class AppTabViewModel {
    
    var moviesGenres: [Genre] = []
    var favoriteMovies: [Movie] = []
    var errorMessage: String?
    
    let repo: AppTabRepoProtocol
    
    init(repo: AppTabRepoProtocol = AppTabRepo()) {
        self.repo = repo
        
        Task {
            await fetchGenres()
        }
    }

    func fetchGenres() async {
        do {
            let genres = try await repo.fetchGenres()
            moviesGenres = genres.genres
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func loadFavorites(ids: [Int]) async {
        do {
            favoriteMovies = try await withThrowingTaskGroup(of: Movie.self) { group in
                for id in ids {
                    group.addTask {
                        try await self.repo.fetchMovieDetails(id: id)
                    }
                }
                
                var results: [Movie] = []
                for try await movie in group {
                    results.append(movie)
                }
                return results
            }
        } catch {
            errorMessage = error.localizedDescription
            print("loadFavorites failed:", error)
        }
    }
}
