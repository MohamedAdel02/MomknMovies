//
//  FavoriteMovie.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 31/08/2026.
//

import Foundation
import SwiftData

@Model
final class FavoriteMovies {
    
    @Attribute(.unique) var userID: String
    var movieIDs: [Int]
    
    init(userID: String, movieIDs: [Int] = []) {
        self.userID = userID
        self.movieIDs = movieIDs
    }
}
