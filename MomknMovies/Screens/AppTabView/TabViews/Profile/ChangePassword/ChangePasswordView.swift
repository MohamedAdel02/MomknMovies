//
//  ChangePasswordView.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 28/08/2026.
//

import SwiftUI

enum ChangePasswordViewField {
    case password, confirmPassword
}

struct ChangePasswordView: View {
    
    @State var viewModel = ChangePasswordViewModel()
    @State private var isSaving = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.showToast) private var showToast
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                background()
                
                VStack(spacing: 30) {
                    
                    TextFieldView(
                        label: "Current Password",
                        placeholder: String(localized: "Enter your current password"),
                        text: $viewModel.currentPasword,
                        isSecured: true,
                        submitLabel: .next
                    )
                    
                    TextFieldView(
                        label: "New Password",
                        placeholder: String(localized: "Enter your new password"),
                        text: $viewModel.password,
                        isSecured: true,
                        submitLabel: .next
                    )
                    
                    TextFieldView(
                        label: "Confirm New Password",
                        placeholder: String(localized: "Re-enter your new password"),
                        text: $viewModel.confirmPassword,
                        isSecured: true,
                        submitLabel: .done
                    )
                    
                    saveButton()
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Change Password")
            .toolbarColorScheme(.dark, for: .navigationBar)
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
        .padding(.top, 25)
    }
    
    private func saveTapped() {
        
        Task {
            isSaving = true
            do {
                let success = try await viewModel.resetPassword()
                isSaving = false
                if success {
                    showToast(.success("Password updated successfully."))
                    dismiss()
                } else {
                    showToast(.error(LocalizedStringKey(viewModel.alertMessage)))
                }
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
    ChangePasswordView()
}
