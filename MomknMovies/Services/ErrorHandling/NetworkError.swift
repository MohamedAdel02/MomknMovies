//
//  NetworkError.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 18/08/2026.
//

import Foundation
import FirebaseAuth

enum NetworkError: LocalizedError {

    //FirebaseAuth
    case invalidEmail
    case emailAlreadyInUse
    case weakPassword
    case wrongPassword
    case userNotFound
    case userDisabled
    case networkError
    case tooManyRequests
    case requiresRecentLogin

    //Networking
    case invalidURL
    case noConnectivity
    case timeout
    case unauthorized
    case server(statusCode: Int)
    case client(statusCode: Int)
    case decoding(String)
    case unknown(String)



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
        case .invalidURL:
            return String(localized: "The request URL is invalid.")
        case .noConnectivity:
            return String(localized: "No internet connection. Please check your network.")
        case .timeout:
            return String(localized: "The request timed out. Please try again.")
        case .unauthorized:
            return String(localized: "You are not authorized to perform this action.")
        case .server(let statusCode):
            return String(localized: "Server error (\(statusCode)). Please try again later.")
        case .client(let statusCode):
            return String(localized: "Request error (\(statusCode)). Please check and try again.")
        case .decoding(let message):
            return String(localized: "Failed to process the response: \(message)")
        case .unknown(let message):
            return String(localized: "Something went wrong: \(message)")
        }
    }
}
