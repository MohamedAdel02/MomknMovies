//
//  NetworkError.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 18/08/2026.
//

import Foundation
import FirebaseAuth

enum NetworkError: LocalizedError {
    case invalidEmail
    case emailAlreadyInUse
    case weakPassword
    case wrongPassword
    case userNotFound
    case userDisabled
    case networkError
    case tooManyRequests
    case requiresRecentLogin
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return String(localized: "The email address is not valid.")
        case .emailAlreadyInUse:
            return String(localized: "An account already exists with this email.")
        case .weakPassword:
            return String(localized: "Password should be at least 6 characters.")
        case .wrongPassword:
            return String(localized: "Incorrect password.")
        case .userNotFound:
            return String(localized: "No account found with this email.")
        case .userDisabled:
            return String(localized: "This account has been disabled.")
        case .networkError:
            return String(localized: "Network error. Please check your connection.")
        case .tooManyRequests:
            return String(localized: "Too many attempts. Please try again later.")
        case .requiresRecentLogin:
            return String(localized: "Please log in again to complete this action.")
        case .unknown:
            return String(localized: "Something went wrong. Please try again.")
        }
    }
}


