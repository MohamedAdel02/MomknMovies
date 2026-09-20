//
//  CredentialStore.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 13/09/2026.
//

import KeychainAccess

enum CredentialStore {
    
    private static let keychain = Keychain(service: "com.momknmovies.auth")
    private static let emailKey = "email"
    private static let passwordKey = "password"
    
    static func hasSavedCredential() -> Bool {
        (try? keychain.get(emailKey)) != nil && (try? keychain.get(passwordKey)) != nil
    }
    
    static func credentials() -> (email: String, password: String)? {
        guard let email = try? keychain.get(emailKey),
              let password = try? keychain.get(passwordKey) else { return nil }
        return (email, password)
    }
    
    static func save(email: String, password: String) {
        do {
            try keychain.set(email, key: emailKey)
            try keychain.set(password, key: passwordKey)
            print("Keychain saved")
        } catch {
            print("Keychain save failed:", error)
        }
    }
    
    static func clear() {
        try? keychain.remove(emailKey)
        try? keychain.remove(passwordKey)
    }
}
