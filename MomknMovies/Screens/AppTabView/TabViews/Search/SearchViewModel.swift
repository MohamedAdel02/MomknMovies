//
//  SearchViewModel.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 26/08/2026.
//

import SwiftUI

enum SearchViewState {
    case idle
    case loading
    case empty
    case loaded([Movie])
    case error(String)
}

@Observable
class SearchViewModel {

    var query: String = "" {
        didSet {
            guard query != oldValue else { return }
            onQueryChange()
        }
    }
    
    private let repo: SearchRepoProtocol
    
    private(set) var state: SearchViewState = .idle
    
    private var searchTask: Task<Void, Never>?
    
    init(repo: SearchRepoProtocol = SearchRepo()) {
        self.repo = repo
    }
    
    func clear() {
        query = ""
        state = .idle
    }
    
    private func onQueryChange() {
        searchTask?.cancel()
        
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            state = .idle
            return
        }
        
        state = .loading
        
        searchTask = Task {
            do {
                try await Task.sleep(nanoseconds: 500_000_000)
                guard !Task.isCancelled else { return }
                
                let results = try await search(trimmed)
                guard !Task.isCancelled else { return }
                
                state = results.isEmpty ? .empty : .loaded(results)
                
                //print(results)
            } catch is CancellationError {
                // superseded by a newer keystroke
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
    
    
    private func search(_ query: String) async throws -> [Movie] {
        return try await repo.getSearchResult(query: query)
    }
    
}
