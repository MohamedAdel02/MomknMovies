//
//  CreateAccountView.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 17/08/2026.
//

import SwiftUI

enum CreateAccountViewField {
    case name, email, password, confirmPassword
}

struct CreateAccountView: View {
    
    @State var viewModel = CreateAccountViewModel()
    @Binding var authMode: AuthMode
    
    @FocusState private var focusedField: CreateAccountViewField?
    
    var body: some View {
        
        VStack(spacing: 13) {
            VStack(spacing: 16) {
                
                TextFieldView(
                    label: "Name",
                    placeholder: String(localized: "Enter your name"),
                    text: $viewModel.name,
                    submitLabel: .next,
                    isInvalid: viewModel.invalidFields.contains(.name)
                )
                .focused($focusedField, equals: .name)
                .onSubmit {
                    focusedField = .email
                }
                
                TextFieldView(
                    label: "Email",
                    placeholder: String(localized: "Enter your email"),
                    text: $viewModel.email,
                    submitLabel: .next,
                    isInvalid: viewModel.invalidFields.contains(.email)
                )
                .focused($focusedField, equals: .email)
                .onSubmit {
                    focusedField = .password
                }
                
                TextFieldView(
                    label: "Password",
                    placeholder: String(localized: "Enter your password"),
                    text: $viewModel.password,
                    isSecured: true,
                    submitLabel: .next,
                    isInvalid: viewModel.invalidFields.contains(.password)
                )
                .focused($focusedField, equals: .password)
                .onSubmit {
                    focusedField = .confirmPassword
                }
                
                TextFieldView(
                    label: "Confirm Password",
                    placeholder: String(localized: "Enter your password again"),
                    text: $viewModel.confirmPassword,
                    isSecured: true,
                    submitLabel: .go,
                    isInvalid: viewModel.invalidFields.contains(.confirmPassword)
                )
                .focused($focusedField, equals: .confirmPassword)
                .onSubmit {
                    createAccountTapped()
                }
                
            }
            .padding(.vertical, 15)
            
            createAccountButton()
                .padding(.bottom, 5)
            
            HStack {
                
                Text("Have an account already?")
                    .font(.footnote)
                    .foregroundColor(.customGray)
                
                loginButton()
            }
            .padding(.bottom, 15)
        }
        .padding(.horizontal, 20)
        .background(Color.background)
        .ignoresSafeArea(edges: .top)
        .contentShape(Rectangle())
        .hideKeyboardOnTap()
        .alert("Error", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
        
    }
    
    func createAccountButton() -> some View {
        
        Button(action: {
            createAccountTapped()
        }) {
            Text("Create Account")
                .font(.headline)
                .foregroundColor(.white)
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
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .disabled(viewModel.createAccountDisabled)
        .opacity(viewModel.createAccountDisabled ? 0.5 : 1)
    }
    
    func loginButton() -> some View {
        
        Button(action: {
            withAnimation(.easeInOut(duration: 0.4)) {
                authMode = .login
            }
        }) {
            
            Text("Login")
                .font(.footnote)
                .foregroundColor(.customGray)
                .underline()
        }
    }
    
    func createAccountTapped() {
        Task {
            await viewModel.createAccount()
        }
    }
    
}

#Preview {
    CreateAccountView(authMode: .constant(.signUp))
}
