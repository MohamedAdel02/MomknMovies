//
//  Router.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 18/08/2026.
//

import SwiftUI

enum MainRoute: Hashable {
    case movieDetails(movie: Movie)
    case allMovies(category: MovieListCategory)
}

enum ProfileRoute: Hashable {
    case movieDetails(movie: Movie)
    case editProfile
    case changePassword
    case allFavorites
}

enum AuthRoute: Hashable {
    case forgetPassword
}

@Observable
class Router<Route: Hashable> {
    var path = NavigationPath()

    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}
