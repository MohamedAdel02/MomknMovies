//
//  CreateAccountViewModel.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 17/08/2026.
//

import SwiftUI

@Observable
class CreateAccountViewModel {
    
    var name = ""
    var email = ""
    var password = ""
    var confirmPassword = ""
    var invalidFields: Set<CreateAccountViewField> = []

    var showAlert = false
    var alertMessage = ""
        
    var createAccountDisabled: Bool {
        name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty
    }
    
    private let authRepository: AuthRepository
    
    @ObservationIgnored @AppStorage("selectedLanguage")
    private var selectedLanguage = "en"

    init(authRepository: AuthRepository = AuthRepository()) {
        self.authRepository = authRepository
    }
    
    func createAccount() async {
        guard checkCredentials() else { return }

        do {
            try await authRepository.createAccount(name: name, email: email, password: password)
            CredentialStore.save(email: email, password: password)
        } catch {
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }
    
    private func checkCredentials() -> Bool {
        
        invalidFields.removeAll()
        var messages: [String] = []
        
        if !name.isValidName() {
            invalidFields.insert(.name)
            messages.append(String.localized("Please enter a valid name.", language: selectedLanguage)
            )
        }
        
        if !email.isValidEmail() {
            invalidFields.insert(.email)
            messages.append(String.localized("Please enter a valid email.", language: selectedLanguage)
            )
        }
        
        if !password.isValidPassword() {
            invalidFields.insert(.password)
            messages.append(String.localized("Please enter a valid password.", language: selectedLanguage)
            )
        }
        
        if password != confirmPassword {
            invalidFields.insert(.password)
            invalidFields.insert(.confirmPassword)
            messages.append(String.localized("Passwords do not match.", language: selectedLanguage)
            )
        }
        
        if !invalidFields.isEmpty {
            alertMessage = messages.joined(separator: "\n")
            showAlert = true
            return false
        }
        
        return true
    }
    
    
}
