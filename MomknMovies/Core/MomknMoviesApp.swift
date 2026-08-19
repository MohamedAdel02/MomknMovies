//
//  MomknMoviesApp.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 17/08/2026.
//

import SwiftUI

@main
struct MomknMoviesApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @AppStorage("selectedLanguage")
    private var selectedLanguage: String?
    
    @State private var router = Router()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if selectedLanguage == nil {
                    LanguageSelectionView()
                } else {
                    MainAuthView()
                        .environment(router)
                        .id(selectedLanguage)
                        .withToast()
                }
            }
            .environment(\.locale, Locale(identifier: selectedLanguage ?? "en"))
            .environment(\.layoutDirection, selectedLanguage == "ar" ? .rightToLeft: .leftToRight)
        }
    }
}
