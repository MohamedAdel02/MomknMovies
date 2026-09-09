//
//  LanguageCardView.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 28/08/2026.
//

import SwiftUI

struct LanguageCardView: View {
    
    @AppStorage("selectedLanguage")
    private var selectedLanguage: String?
    
    @State private var chosenLanguage: AppLanguage = .arabic
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            
            Capsule()
                .fill(Color.white.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.top, 12)
            
            Text("Choose Your Language")
                .font(.title3.bold())
                .foregroundStyle(.white)
            
            Text("اختر لغة التطبيق")
                .font(.headline)
                .bold()
                .foregroundStyle(Color.white.opacity(0.6))
                .padding(.bottom, 15)
            
            VStack(spacing: 16) {
                ForEach(AppLanguage.allCases, id: \.self) { language in
                    languageRow(language)
                }
            }
            
            confirmButton
            
            Spacer(minLength: 8)
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(Color.black.opacity(0.55))
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 32))
                .environment(\.colorScheme, .dark)
                .ignoresSafeArea(edges: .bottom)
        )
        .frame(height: 400)
        .onAppear {
            if let saved = selectedLanguage, let lang = AppLanguage(rawValue: saved) {
                chosenLanguage = lang
            }
        }
    }
    
    private func languageRow(_ language: AppLanguage) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                chosenLanguage = language
            }
        } label: {
            HStack {
                Text(language.flag)
                    .font(.title2)
                
                Text(language.displayName)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.white)
                
                Spacer()
                
                Image(systemName: chosenLanguage == language ? "largecircle.fill.circle" : "circle")
                    .foregroundStyle(chosenLanguage == language ? Color.buttonGradient2.opacity(0.9) : Color.white.opacity(0.4))
                    .font(.title3)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(chosenLanguage == language ? Color.buttonGradient1.opacity(0.2) : Color.white.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(chosenLanguage == language ? Color.buttonGradient1 : Color.white.opacity(0.15), lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
    
    private var confirmButton: some View {
        Button {
            selectedLanguage = chosenLanguage.rawValue
            dismiss()
        } label: {
            Text("Confirm")
                .font(.body.weight(.semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RadialGradient(
                        colors: [Color.buttonGradient1, Color.buttonGradient2],
                        center: .center,
                        startRadius: 5,
                        endRadius: 200
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    LanguageCardView()
}
