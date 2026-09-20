//
//  ProfileView.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 26/08/2026.
//

import SwiftUI
import FirebaseAuth
import SwiftData

struct ProfileView: View {
    
    
    @Environment(Router<ProfileRoute>.self) private var router
    @Environment(AppTabViewModel.self) private var appTabViewModel

    @AppStorage("selectedLanguage") private var selectedLanguage: String = "en"
    @AppStorage(UserSessionKeys.uid) private var userId: String = ""
    @AppStorage(UserSessionKeys.name) private var userName: String = ""
    @AppStorage(UserSessionKeys.email) private var userEmail: String = ""
    @AppStorage(UserSessionKeys.memberSince) private var memberSince: String = ""
    
    @State private var showLanguageSelection = false
    @State private var showDeleteAlert = false
    @State private var showReauthPrompt = false
    @State private var reauthPassword = ""
    @State private var deleteErrorMessage: String?
    @State private var showDeleteError = false
    @State private var showSignOutAlert = false
    @Environment(\.modelContext) private var modelContext
    @Query private var favoriteMovies: [FavoriteMovies]
        
    private var currentLanguageName: String {
        AppLanguage(rawValue: selectedLanguage)?.displayName ?? "English"
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                background()
                
                ScrollView {
                    VStack(spacing: 24) {
                        header
                        FavoritesView(favorites: appTabViewModel.favoriteMovies, geometry: geometry)
                        settingsSection
                        accountSection
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
                .scrollIndicators(.hidden)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: ProfileRoute.self) { route in
                destinationView(for: route)
            }
        }
        .sheet(isPresented: $showLanguageSelection) {
            LanguageCardView()
                .presentationDetents([.height(400)])
                .presentationDragIndicator(.hidden)
                .presentationBackground(.background2)
        }
    }
    
    
    private var header: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(.textField.opacity(0.2))
                    .frame(width: 90, height: 90)
                    .overlay {
                        Image(systemName: "person.fill")
                            .font(.system(size: 36))
                            .foregroundStyle(Color.customGray.opacity(0.6))
                    }
            }
            
            VStack(spacing: 4) {
                Text(userName.isEmpty ? "Guest" : userName)
                    .multilineTextAlignment(.center)
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                
                Text(userEmail)
                    .font(.subheadline)
                    .foregroundStyle(.blue)
                
                if !memberSince.isEmpty {
                    Text("Member since \(memberSince)")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.5))
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }
    
    
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Settings")
            
            VStack(spacing: 0) {
                settingsRow(icon: "globe", title: "Language", trailing: currentLanguageName) {
                    showLanguageSelection = true
                }
            }
            .background(.customGray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .padding(.horizontal)
    }
    
    
    private var accountSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Account")
            
            VStack(spacing: 0) {
                settingsRow(icon: "pencil", title: "Edit Account") {
                    router.push(.editProfile)
                }
                Divider().padding(.leading, 44).background(.white.opacity(0.1))
                settingsRow(icon: "lock", title: "Change Password") {
                    router.push(.changePassword)
                }
                Divider().padding(.leading, 44).background(.white.opacity(0.1))
                settingsRow(icon: "rectangle.portrait.and.arrow.right", title: "Sign Out") {
                    showSignOutAlert = true
                }
                Divider().padding(.leading, 44).background(.white.opacity(0.1))
                settingsRow(icon: "trash", title: "Delete Account", isDestructive: true) {
                    showDeleteAlert = true
                }
            }
            .background(.customGray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .padding(.horizontal)
        .background { signOutAlert }
        .background { deleteAccountAlert }
        .background { reauthAlert }
        .background { deleteErrorAlert }
    }

    private var signOutAlert: some View {
        LocalizedAlert(
            isPresented: $showSignOutAlert,
            title: String.localized("Sign Out?", language: selectedLanguage),
            message: String.localized("Are you sure you want to sign out?", language: selectedLanguage),
            buttons: signOutButtons,
            isArabic: selectedLanguage == "ar"
        )
    }

    private var signOutButtons: [LocalizedAlertButton] {
        [
            LocalizedAlertButton(String.localized("Cancel", language: selectedLanguage), role: .cancel),
            LocalizedAlertButton(String.localized("Sign Out", language: selectedLanguage), role: .destructive) {
                signOutTapped()
            }
        ]
    }

    private var deleteAccountAlert: some View {
        LocalizedAlert(
            isPresented: $showDeleteAlert,
            title: String.localized("Delete Account?", language: selectedLanguage),
            message: String.localized("This will permanently delete your account and cannot be undone.", language: selectedLanguage),
            buttons: deleteAccountButtons,
            isArabic: selectedLanguage == "ar"
        )
    }

    private var deleteAccountButtons: [LocalizedAlertButton] {
        [
            LocalizedAlertButton(String.localized("Cancel", language: selectedLanguage), role: .cancel),
            LocalizedAlertButton(String.localized("Delete", language: selectedLanguage), role: .destructive) {
                deleteAccountTapped()
            }
        ]
    }

    private var reauthAlert: some View {
        LocalizedAlert(
            isPresented: $showReauthPrompt,
            title: String.localized("Re-enter Password", language: selectedLanguage),
            message: String.localized("For your security, please confirm your password to delete your account.", language: selectedLanguage),
            buttons: reauthButtons,
            isArabic: selectedLanguage == "ar",
            secureFieldPlaceholder: String.localized("Password", language: selectedLanguage),
            secureFieldText: $reauthPassword
        )
    }

    private var reauthButtons: [LocalizedAlertButton] {
        [
            LocalizedAlertButton(String.localized("Cancel", language: selectedLanguage), role: .cancel) {
                reauthPassword = ""
            },
            LocalizedAlertButton(String.localized("Confirm", language: selectedLanguage), role: .default) {
                reauthenticateAndDelete()
            }
        ]
    }

    private var deleteErrorAlert: some View {
        LocalizedAlert(
            isPresented: $showDeleteError,
            title: String.localized("Error", language: selectedLanguage),
            message: deleteErrorMessage ?? String.localized("Something went wrong.", language: selectedLanguage),
            buttons: deleteErrorButtons,
            isArabic: selectedLanguage == "ar"
        )
    }

    private var deleteErrorButtons: [LocalizedAlertButton] {
        [LocalizedAlertButton(String.localized("OK", language: selectedLanguage), role: .cancel)]
    }
    
    
    private func sectionHeader(_ title: LocalizedStringKey) -> some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(.white)
    }
    
    private func settingsRow(icon: String, title: LocalizedStringKey, trailing: String? = nil, isDestructive: Bool = false, action: @escaping () -> Void = {}) -> some View {
          Button(action: action) {
              HStack(spacing: 12) {
                  Image(systemName: icon)
                      .font(.system(size: 15))
                      .foregroundStyle(isDestructive ? .red : .white)
                      .frame(width: 22)
                  
                  Text(title)
                      .font(.subheadline)
                      .foregroundStyle(isDestructive ? .red : .white)
                  
                  Spacer()
                  
                  if let trailing {
                      Text(trailing)
                          .font(.subheadline)
                          .foregroundStyle(Color.customGray.opacity(0.8))
                  }
                  
                  Image(systemName: selectedLanguage == "ar" ? "chevron.left" : "chevron.right")
                      .font(.system(size: 12))
                      .foregroundStyle(Color.customGray.opacity(0.5))
              }
              .padding(12)
          }
          .buttonStyle(.plain)
      }
    

    private func background() -> some View {
        LinearGradient(
            colors: [.background2, .background],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private func signOutTapped() {
        CredentialStore.clear()
        try? AuthRepository().logout()
    }
    
    private func deleteAccountTapped() {
        //let userID = Auth.auth().currentUser?.uid
        
        Task {
            do {
                try await AuthRepository().deleteAccount()
                CredentialStore.clear()
                
//                if let userID, let favorites = favoriteMovies.first(where: { $0.userID == userID }) {
//                    modelContext.delete(favorites)
//                    try? modelContext.save()
//                }
                
            } catch NetworkError.requiresRecentLogin {
                showReauthPrompt = true
            } catch {
                deleteErrorMessage = error.localizedDescription
                showDeleteError = true
            }
        }
    }
    
    private func reauthenticateAndDelete() {
        Task {
            do {
                try await AuthRepository().reauthenticate(password: reauthPassword)
                reauthPassword = ""
                try await AuthRepository().deleteAccount()
            } catch {
                reauthPassword = ""
                deleteErrorMessage = error.localizedDescription
                showDeleteError = true
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: ProfileRoute) -> some View {
        switch route {
        case .movieDetails(let movie):
            MovieDetailsView(movie: movie)
        case .editProfile:
            EditProfileView()
        case .changePassword:
            ChangePasswordView()
        case .allFavorites:
            AllFavoritesView()
        }
    }
}

#Preview {
    ProfileView()
}
