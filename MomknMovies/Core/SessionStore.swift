//
//  SessionStore.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 28/08/2026.
//

import Foundation
import FirebaseAuth
import Observation

@Observable
class SessionStore {
    
    var isSignedIn: Bool?
    var userID: String?
    
    private var handle: AuthStateDidChangeListenerHandle?
    
    init() {
        listen()
    }
    
    private func listen() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            print("Auth state changed — user:", user?.uid ?? "nil")
            self?.isSignedIn = (user != nil)
            self?.userID = user?.uid
        }
    }
    
//    deinit {
//        if let handle {
//            Auth.auth().removeStateDidChangeListener(handle)
//        }
//    }
}
