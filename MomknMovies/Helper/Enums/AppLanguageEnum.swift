//
//  AppLanguageEnum.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 29/08/2026.
//

import Foundation

enum AppLanguage: String, CaseIterable {
    case english = "en"
    case arabic = "ar"
    
    var displayName: String {
        switch self {
        case .english:
            return "English"
        case .arabic:
            return "العربية"
        }
    }
    
    var flag: String {
        switch self {
        case .english:
            return "🇺🇸"
        case .arabic:
            return "🇪🇬"
        }
    }
}
