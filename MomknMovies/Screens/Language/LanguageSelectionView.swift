//
//  LanguageSelectionView.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 19/08/2026.
//
import SwiftUI

struct LanguageSelectionView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                background(geometry: geometry)
                LanguageCardView()
            }
        }
        .ignoresSafeArea()
    }
    
    private func background(geometry: GeometryProxy) -> some View {
        Image(.dunkirk)
            .resizable()
            .scaledToFill()
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipped()
            .overlay(Color.black.opacity(0.3))
            .ignoresSafeArea()
    }
}


#Preview {
    LanguageSelectionView()
}
