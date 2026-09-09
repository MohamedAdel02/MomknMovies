//
//  EditProfileView.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 28/08/2026.
//

import SwiftUI

struct EditProfileView: View {
    
    @AppStorage(UserSessionKeys.name) private var storedName: String = ""
    @AppStorage(UserSessionKeys.email) private var storedEmail: String = ""
    
    @State var name = ""
    @State private var isSaving = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.showToast) private var showToast
    
    private var saveDisabled: Bool {
        name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSaving
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                background()
                
                VStack(spacing: 30) {
                    
                    TextFieldView(
                        label: "Email",
                        placeholder: String(localized: "Enter your email"),
                        text: .constant(storedEmail),
                        submitLabel: .next,
                        isDisabled: true
                    )
                    
                    TextFieldView(
                        label: "Name",
                        placeholder: String(localized: "Enter your name"),
                        text: $name,
                        submitLabel: .done
                    )
                    
                    saveButton()
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Edit Account")
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .onAppear {
            name = storedName
        }
    }
    
    private func saveButton() -> some View {
        
        Button(action: {
            saveTapped()
        }) {
            Group {
                if isSaving {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Save")
                        .font(.headline)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(
                RadialGradient(
                    colors: [Color.buttonGradient1, Color.buttonGradient2],
                    center: .center,
                    startRadius: 5,
                    endRadius: 200
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .disabled(saveDisabled)
        .opacity(saveDisabled ? 0.5 : 1)
        .padding(.top, 25)
    }
    
    private func saveTapped() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Task {
            isSaving = true
            do {
                try await AuthRepository().updateName(trimmedName)
                isSaving = false
                showToast(.success("Profile updated successfully."))
                dismiss()
            } catch {
                isSaving = false
                showToast(.error(LocalizedStringKey(error.localizedDescription)))
            }
        }
    }
    
    private func background() -> some View {
        LinearGradient(
            colors: [.background2, .background],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

#Preview {
    EditProfileView()
}
