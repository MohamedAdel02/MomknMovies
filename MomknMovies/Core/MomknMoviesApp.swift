//
//  MomknMoviesApp.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 17/08/2026.
//

import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseAuth

@main
struct MomknMoviesApp: App {
        
    @AppStorage("selectedLanguage")
    private var selectedLanguage: String?
    
    @State private var router = Router<AuthRoute>()
    @State private var session: SessionStore
    @State private var selectedTab = 0
    
    init() {
        FirebaseApp.configure()
        
        if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            try? Auth.auth().signOut()
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        }
        
        _session = State(initialValue: SessionStore())
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if selectedLanguage == nil {
                    LanguageSelectionView()
                } else if let isSignedIn = session.isSignedIn {
                    if isSignedIn {
                        AppTabView(selectedTab: $selectedTab, userID: session.userID ?? "")
                            .modelContainer(for: FavoriteMovies.self)
                            .id(selectedLanguage)
                    } else {
                        MainAuthView()
                            .environment(router)
                            .id(selectedLanguage)
                    }
                } else {
                    ProgressView()
                }
            }
            .withToast()
            .environment(\.locale, Locale(identifier: selectedLanguage ?? "en"))
            .environment(\.layoutDirection, selectedLanguage == "ar" ? .rightToLeft : .leftToRight)
            .onChange(of: session.isSignedIn) { _, newValue in
                if newValue == false {
                    selectedTab = 0
                }
            }
        }
    }
}
