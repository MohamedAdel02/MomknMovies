//
//  Router.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 18/08/2026.
//

import SwiftUI

enum Route: Hashable {
    case forgetPassword
}

@Observable
class Router {
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
