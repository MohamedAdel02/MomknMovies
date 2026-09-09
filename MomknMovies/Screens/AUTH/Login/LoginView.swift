//
//  LoginView.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 17/08/2026.
//

import SwiftUI

enum LoginViewField {
    case email, password
}

struct LoginView: View {
    
    @State var viewModel = LoginViewModel()
    @Binding var authMode: AuthMode
    
    @Environment(\.showToast) private var showToast
    @AppStorage("selectedLanguage") private var selectedLanguage = "en"
    @Environment(Router<AuthRoute>.self) private var router
    @FocusState private var focusedField: LoginViewField?
    @State private var isSaving = false
    
        
    var body: some View {
        
        VStack(spacing: 15) {
            VStack(spacing: 18) {
                
                TextFieldView(
                    label: "Email",
                    placeholder: String(localized: "Enter your email"),
                    text: $viewModel.email,
                    submitLabel: .next
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
                    submitLabel: .go
                )
                .focused($focusedField, equals: .password)
                .onSubmit {
                    loginTapped()
                }
            }
            .padding(.top, 15)
            
            HStack {
                
                Spacer()
                forgetPasswordButton()
            }
            
            loginButton()
                .padding(.bottom, 5)
            
            HStack {
                
                Text("Don't have an account?")
                    .font(.footnote)
                    .foregroundColor(.customGray)
                
                signUpButton()
            }
            .padding(.bottom, 15)
        }
        .padding(.horizontal, 20)
        .background(Color.background)
        .ignoresSafeArea(edges: .top)
        .contentShape(Rectangle())
        .hideKeyboardOnTap()
        .onChange(of: viewModel.showAlert) { _, isShowing in
            if isShowing {
                showToast(.error(LocalizedStringKey(viewModel.alertMessage)))
                viewModel.showAlert = false
            }
        }

            

    }
    
    func forgetPasswordButton() -> some View {
        Button(action: {
            router.push(.forgetPassword)
        }) {
            Text("Forget Password?")
                .font(.footnote)
                .foregroundColor(.customGray)
        }
    }
    
    func loginButton() -> some View {
        
        Button(action: {
            loginTapped()
        }) {
            Group {
                if isSaving {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Log In")
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
        .disabled(viewModel.loginIsDisabled)
        .opacity(viewModel.loginIsDisabled ? 0.5 : 1)
        
    }
    
    func signUpButton() -> some View {
        
        Button(action: {
            withAnimation(.easeInOut(duration: 0.4)) {
                authMode = .signUp
            }
        }) {
            
            Text("Sign up")
                .font(.footnote)
                .foregroundColor(.customGray)
                .underline()
        }
    }
    
    func loginTapped() {
        Task {
            isSaving = true
            await viewModel.login()
            isSaving = false
        }
    }
    
}

#Preview {
    LoginView(authMode: .constant(AuthMode.login))
}


