//
//  UserSessionManager.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 28/08/2026.
//

import Foundation

enum UserSessionKeys {
    static let uid = "userId"
    static let name = "userName"
    static let email = "userEmail"
    static let memberSince = "memberSince"
}

struct UserSessionManager {
    
    static func save(uid: String, name: String, email: String) {
        let defaults = UserDefaults.standard
        defaults.set(uid, forKey: UserSessionKeys.uid)
        defaults.set(name, forKey: UserSessionKeys.name)
        defaults.set(email, forKey: UserSessionKeys.email)
        
        if defaults.string(forKey: UserSessionKeys.memberSince) == nil {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            defaults.set(formatter.string(from: Date()), forKey: UserSessionKeys.memberSince)
        }
    }
    
    static func clear() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: UserSessionKeys.uid)
        defaults.removeObject(forKey: UserSessionKeys.name)
        defaults.removeObject(forKey: UserSessionKeys.email)
        defaults.removeObject(forKey: UserSessionKeys.memberSince)
    }
}
