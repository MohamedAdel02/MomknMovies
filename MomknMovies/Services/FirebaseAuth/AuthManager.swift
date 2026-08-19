//
//  AuthManager.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 18/08/2026.
//

import Foundation
import FirebaseAuth

class AuthManager {
    
    static let shared = AuthManager()
    
    private init() { }
    
    func createAccount(name: String, email: String, password: String) async throws {
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = name
            try await changeRequest.commitChanges()
            
        } catch {
            throw mapError(error)
        }
    }
    
    
    func login(email: String, password: String) async throws {
        
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            throw mapError(error)
        }
    }
    
    
    func resetPassword(email: String) async throws {
        
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            throw mapError(error)
        }
    }
    
    
    func logout() throws {
        
        do {
            try Auth.auth().signOut()
        } catch {
            throw mapError(error)
        }
    }
    
    
    private func mapError(_ error: Error) -> NetworkError {
        
        let nsError = error as NSError
        
        guard let errorCode = AuthErrorCode(rawValue: nsError.code) else {
            return .unknown
        }
        
        switch errorCode {
        case .invalidEmail:
            return .invalidEmail
        case .emailAlreadyInUse:
            return .emailAlreadyInUse
        case .weakPassword:
            return .weakPassword
        case .wrongPassword:
            return .wrongPassword
        case .userNotFound:
            return .userNotFound
        case .userDisabled:
            return .userDisabled
        case .networkError:
            return .networkError
        case .tooManyRequests:
            return .tooManyRequests
        case .requiresRecentLogin:
            return .requiresRecentLogin
        default:
            return .unknown
        }
    }
}
