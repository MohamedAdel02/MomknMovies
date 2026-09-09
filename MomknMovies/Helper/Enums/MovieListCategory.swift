//
//  MovieListCategory.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 05/09/2026.
//

import SwiftUI

enum MovieListCategory: String, CaseIterable {
    case popular
    case topRated
    case commingSoon

    var title: LocalizedStringKey {
        switch self {
        case .popular:
            return "Popular Movies"
        case .topRated:
            return "Top Rated"
        case .commingSoon:
            return "Comming Soon"
        }
    }
}
