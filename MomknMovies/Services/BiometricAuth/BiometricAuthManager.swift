//
//  BiometricAuthManager.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 13/09/2026.
//

//import LocalAuthentication
//
//@Observable
//class BiometricAuthManager {
//    
//    var isUnlocked = false
//    var errorMessage: String?
//
//    func authenticate() {
//        
//        let context = LAContext()
//        var error: NSError?
//
//        // Check if Face ID / Touch ID is available
//        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//            let reason = "Log in to your account"
//
//            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
//                DispatchQueue.main.async {
//                    if success {
//                        self.isUnlocked = true
//                    } else {
//                        self.errorMessage = authError?.localizedDescription ?? "Authentication failed"
//                    }
//                }
//            }
//        } else {
//            // No biometrics available (e.g., not enrolled, or device doesn't support it)
//            errorMessage = error?.localizedDescription ?? "Biometrics not available"
//        }
//    }
//}



import LocalAuthentication

@Observable
class BiometricAuthManager {
    var errorMessage: String?

    func authenticate() async -> Bool {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            errorMessage = error?.localizedDescription ?? "Biometrics not available"
            return false
        }

        do {
            return try await context.evaluatePolicy(
                .deviceOwnerAuthentication,
                localizedReason: "Log in to your account"
            )
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
