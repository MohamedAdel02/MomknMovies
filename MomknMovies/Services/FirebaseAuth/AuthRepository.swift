//
//  AuthRepository.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 19/08/2026.
//

import Foundation

class AuthRepository {
    
    private let authManager = AuthManager.shared
    
    func login(email: String, password: String) async throws {
        try await authManager.login(email: email, password: password)
    }
    
    func createAccount(name: String, email: String, password: String) async throws {
        try await authManager.createAccount(name: name, email: email, password: password)
    }
    
    func resetPassword(email: String) async throws {
        try await authManager.resetPassword(email: email)
    }
    
    func logout() throws {
        try authManager.logout()
    }
    
    func updateName(_ name: String) async throws {
        try await authManager.updateName(name)
    }
    
    func changePassword(currentPassword: String, newPassword: String) async throws {
        try await authManager.changePassword(currentPassword: currentPassword, newPassword: newPassword)
    }
    
    func reauthenticate(password: String) async throws {
        try await authManager.reauthenticate(password: password)
    }
    
    func deleteAccount() async throws {
        try await authManager.deleteAccount()
    }
    

}
