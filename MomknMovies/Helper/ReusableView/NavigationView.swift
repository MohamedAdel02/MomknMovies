//
//  NavigationView.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 21/08/2026.
//

import SwiftUI

struct NavigationView: View {
    
    let isArabic = (UserDefaults.standard.string(forKey: "selectedLanguage") ?? "ar") == "ar"
    
    let geometry: GeometryProxy
    
    var body: some View {
        
        ZStack {

            LinearGradient(
                colors: [.background.opacity(0.4), .background],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(
                width: geometry.size.width,
                height: geometry.size.height * 0.15,
            )

            
            VStack {
                
                Spacer()
                
                HStack(alignment: .center, spacing: 10) {
                    
                    appIcon()
                    
                    appName()

                    Spacer()                    
                    
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)

            }
        }
        .frame(
            width: geometry.size.width,
            height: geometry.size.height * 0.15,
        )
        
    }
    
    private func appIcon() -> some View {
        
        Image(.appIcon)
            .resizable()
            .scaledToFill()
            .frame(
                width: 40,
                height: 40,
            )
            .clipped()
            .ignoresSafeArea()
    }
    
    private func appName() -> some View {
        
        Text("MomknMovies")
            .foregroundStyle(.white.opacity(0.8))
            .font(isArabic ? .custom("Lalezar-Regular", size: 36) : .system(size: 36, weight: .bold))
            .bold()
            .padding(.bottom, -10)
    }

}

//#Preview {
//    NavigationView()
//}
