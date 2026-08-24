//
//  AppTabView.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 22/08/2026.
//

import SwiftUI

struct AppTabView: View {
    var body: some View {
        
        TabView {
            Tab("Home", systemImage: "house") {
                    HomeView()
                
            }
            
            Tab("Search" , systemImage: "magnifyingglass") {
                SearchView()
                
            }
            
            Tab("Profile" , systemImage: "person") {
                ProfileView()
                
            }
                    
        }
        .tint(Color.buttonGradient2)
    }
}

#Preview {
    AppTabView()
}



struct SearchView: View {
    var body: some View {
        NavigationStack {
            Text("Search")
                .navigationTitle("Search")
        }
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            Text("Profile")
                .navigationTitle("Profile")
        }
    }
}
