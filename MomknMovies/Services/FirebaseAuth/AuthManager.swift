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
            
            UserSessionManager.save(uid: result.user.uid, name: name, email: email)
            
        } catch {
            throw mapError(error)
        }
    }
    

    func login(email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            UserSessionManager.save(uid: result.user.uid, name: result.user.displayName ?? "", email: email)
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
    
    func updateName(_ name: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw NetworkError.userNotFound
        }
        
        do {
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = name
            try await changeRequest.commitChanges()
            
            UserSessionManager.save(uid: user.uid, name: name, email: user.email ?? "")
            
        } catch {
            throw mapError(error)
        }
    }
    
    func changePassword(currentPassword: String, newPassword: String) async throws {
        guard let user = Auth.auth().currentUser, let email = user.email else {
            throw NetworkError.userNotFound
        }
        
        
        do {
            let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
            try await user.reauthenticate(with: credential)
             try await user.updatePassword(to: newPassword)
        } catch {
            throw mapError(error)
        }
    }
    
    func reauthenticate(password: String) async throws {
                
        guard let user = Auth.auth().currentUser, let email = user.email else {
            throw NetworkError.userNotFound
        }
        
        do {
            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            try await user.reauthenticate(with: credential)
        } catch {
            throw mapError(error)
        }
    }
    
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else {
            throw NetworkError.userNotFound
        }
        
        do {
            try await user.delete()
            UserSessionManager.clear()
        } catch {
            throw mapError(error)
        }
    }
    
    
    func logout() throws {
        
        do {
            try Auth.auth().signOut()
            UserSessionManager.clear()
        } catch {
            throw mapError(error)
        }
    }
    
    
    private func mapError(_ error: Error) -> NetworkError {
        
        let nsError = error as NSError
        
        guard let errorCode = AuthErrorCode(rawValue: nsError.code) else {
            return .unknown(nsError.localizedDescription)
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
            return .unknown(nsError.localizedDescription)
        }
    }
}
