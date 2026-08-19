//
//  ForgetPasswordView.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 17/08/2026.
//

import SwiftUI

struct ForgetPasswordView: View {
    
    @State var viewModel = ForgetPasswordViewModel()
    
    @AppStorage("selectedLanguage") private var selectedLanguage: String?
    @Environment(\.dismiss) private var dismiss
    @Environment(\.showToast) private var showToast
    @Environment(Router.self) private var router
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                
                background(geometry: geometry)
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    Text("Forget Password")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Text("Enter your email to reset your password")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(.white)
                    
                    TextFieldView(
                        label: "Email",
                        placeholder: String(localized: "Enter your email"),
                        text: $viewModel.email,
                        submitLabel: .go,
                        labelSize: 17
                    )
                    .padding(.top, 20)
                    .onSubmit {
                        resetPasswordTapped()
                    }
                    
                    resetPasswordButton()
                        .padding(.top, 15)
                    
                    Spacer()
                }
                .padding(.top, 130)
                .padding(.horizontal, 20)
                
            }
            .contentShape(Rectangle())
            .hideKeyboardOnTap()
            .alert("Error", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.alertMessage)
            }
            
        }
        .ignoresSafeArea()
    }
    
    
    func background(geometry: GeometryProxy) -> some View {
        
        Image(.laLaLand)
            .resizable()
            .scaledToFill()
            .frame(
                width: geometry.size.width,
                height: geometry.size.height,
                alignment: selectedLanguage == "ar" ? .trailing : .leading
            )
            .clipped()
            .overlay(Color.black.opacity(0.3))
            .ignoresSafeArea()
    }
    
    
    func resetPasswordButton() -> some View {
        
        Button {
            
            resetPasswordTapped()
        } label: {
            Text("Reset your password")
                .font(.system(size: 20))
                .bold()
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    RadialGradient(
                        colors: [Color.buttonGradient1, Color.buttonGradient2],
                        center: .center,
                        startRadius: 5,
                        endRadius: 200
                    )
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 15)
                )
        }
        .disabled(viewModel.buttonIsDisabled)
        .opacity(viewModel.buttonIsDisabled ? 0.5 : 1)
    }
    
    func resetPasswordTapped() {
        Task {
            if await viewModel.resetPassword() {
                
                showToast(.success("A password reset link has been sent to your email."))
                dismiss()
            }
        }
    }
    
}

#Preview {
    ForgetPasswordView()
}

