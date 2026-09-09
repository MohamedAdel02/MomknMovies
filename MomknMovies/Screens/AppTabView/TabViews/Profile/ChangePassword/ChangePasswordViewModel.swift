//
//  ChangePasswordViewModel.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 29/08/2026.
//

import Foundation

@Observable
class ChangePasswordViewModel {
       
    var currentPasword = ""
    var password = ""
    var confirmPassword = ""
    var invalidFields: Set<CreateAccountViewField> = []

    var showAlert = false
    var alertMessage = ""
        
    var buttonIsDisabled: Bool {
        currentPasword.isEmpty || password.isEmpty || confirmPassword.isEmpty
    }
    
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository = AuthRepository()) {
        self.authRepository = authRepository
    }
    
    func resetPassword() async throws -> Bool {
        guard checkCredentials() else { return false }
        
        try await authRepository.changePassword(currentPassword: currentPasword, newPassword: password)
        return true
    }
    
    
    func checkCredentials() -> Bool {
        
        invalidFields.removeAll()
        var messages: [String] = []
        
        if !currentPasword.isValidPassword() {
            invalidFields.insert(.password)
            messages.append(String(localized: "Please enter a valid current password."))
        }
        
        if !password.isValidPassword() {
            invalidFields.insert(.password)
            messages.append(String(localized: "Please enter a valid new password."))
        }
        
        if password != confirmPassword {
            invalidFields.insert(.password)
            invalidFields.insert(.confirmPassword)
            messages.append(String(localized: "Passwords do not match."))
        }
        
        if !invalidFields.isEmpty {
            alertMessage = messages.joined(separator: "\n")
            showAlert = true
            return false
        }
        
        return true
    }
    
}
