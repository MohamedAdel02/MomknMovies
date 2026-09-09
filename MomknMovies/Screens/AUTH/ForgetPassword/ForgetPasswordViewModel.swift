//
//  ForgetPasswordViewModel.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 17/08/2026.
//

import SwiftUI

@Observable
class ForgetPasswordViewModel {
  
    var email = ""
    
    var showAlert = false
    var alertMessage = ""
    
    var buttonIsDisabled: Bool {
        email.isEmpty
    }
    
    @ObservationIgnored @AppStorage("selectedLanguage")
    private var selectedLanguage = "en"

    private let authRepository: AuthRepository

    init(authRepository: AuthRepository = AuthRepository()) {
        self.authRepository = authRepository
    }
    
    func resetPassword() async -> Bool {
        guard checkCredentials() else { return false }
        
        do {
            try await authRepository.resetPassword(email: email)
            return true
        } catch {
            alertMessage = error.localizedDescription
            showAlert = true
            return false
        }
    }
    
    
    func checkCredentials() -> Bool {
        guard email.isValidEmail() else {
            alertMessage = String.localized(
                "Please enter a valid email.",
                language: selectedLanguage
            )
            showAlert = true
            return false
        }
        
        return true
    }

    
}


