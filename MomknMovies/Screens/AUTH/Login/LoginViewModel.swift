//
//  LoginViewModel.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 17/08/2026.
//

import SwiftUI

@Observable
class LoginViewModel {
  
    var email = ""
    var password = ""
    
    var showAlert = false
    var alertMessage = ""
    
    var loginIsDisabled: Bool {
        email.isEmpty || password.isEmpty
    }
    
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository = AuthRepository()) {
        self.authRepository = authRepository
    }
    
    func login() async {
        guard checkCredentials() else { return }
        
        do {
            try await authRepository.login(email: email, password: password)
        } catch {
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }
    
    private func checkCredentials() -> Bool {
        guard email.isValidEmail() && password.isValidPassword() else {
            alertMessage = String(localized:"Please enter a valid email and password.")
            showAlert = true
            return false
        }

        return true
    }
    
}


