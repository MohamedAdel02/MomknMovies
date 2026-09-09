//
//  String+Extensions.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 18/08/2026.
//

import Foundation

extension String {
    
    func isValidEmail() -> Bool {
        let regex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        return self.count >= 8
    }
    
    func isValidName() -> Bool {
        let regex = "^[a-zA-Z\\s]{3,50}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }
}

extension String {
    static func localized(_ key: String.LocalizationValue) -> String {
        let lang = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"
        return String(localized: key, locale: Locale(identifier: lang))
    }
}


extension String {

    static func localized(_ key: String, language: String) -> String {

        guard let path = Bundle.main.path(forResource: language, ofType: "lproj"), let bundle = Bundle(path: path) else {
            return NSLocalizedString(key, comment: "")
        }

        return NSLocalizedString(key, bundle: bundle, comment: "")

    }

}
