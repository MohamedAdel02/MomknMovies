//
//  Cast.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 24/08/2026.
//

import Foundation


struct CastResult: Codable {
    let id: Int
    let cast: [Cast]

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case cast = "cast"
    }
}


struct Cast: Codable {
    let adult: Bool
    let gender: Int
    let id: Int
    let knownForDepartment: Department
    let name: String
    let originalName: String
    let popularity: Double
    let profilePath: String?
    let castID: Int?
    let character: String?
    let creditID: String


    enum CodingKeys: String, CodingKey {
        case adult = "adult"
        case gender = "gender"
        case id = "id"
        case knownForDepartment = "known_for_department"
        case name = "name"
        case originalName = "original_name"
        case popularity = "popularity"
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character = "character"
        case creditID = "credit_id"
    }
}

enum Department: String, Codable {
    case acting = "Acting"
    case art = "Art"
    case camera = "Camera"
    case costumeMakeUp = "Costume & Make-Up"
    case crew = "Crew"
    case directing = "Directing"
    case editing = "Editing"
    case lighting = "Lighting"
    case production = "Production"
    case sound = "Sound"
    case visualEffects = "Visual Effects"
    case writing = "Writing"
}
