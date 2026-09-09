//
//  SearchView.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 26/08/2026.
//

import SwiftUI
import Combine
import SkeletonUI

struct SearchView: View {
    
    @State var viewModel = SearchViewModel()
    @FocusState private var isSearchFieldFocused: Bool
    
    @Environment(Router<MainRoute>.self) private var router
    
    @AppStorage("selectedLanguage")private var selectedLanguage: String?
    @Environment(\.layoutDirection) private var layoutDirection

    private var localizedSearchPlaceholder: String {
        let languageCode = selectedLanguage ?? "en"
        
        guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
              let languageBundle = Bundle(path: path)
        else {
            return "Search movies"
        }
        
        return languageBundle.localizedString(
            forKey: "Search movies",
            value: "Search movies",
            table: nil
        )
    }
        
    var body: some View {
        ZStack {
            
            background()
            
            VStack(spacing: 16) {
                searchBar()
                    .padding(.horizontal)
                
                content()
            }
            .safeAreaPadding(.top, 12)
        }
        .navigationTitle("Search")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .ignoresSafeArea(edges: .bottom)
        .contentShape(Rectangle())
        .hideKeyboardOnTap()
        .navigationDestination(for: MainRoute.self) { route in
            destinationView(for: route)
        }
    }
    
    
    private func searchBar() -> some View {
        HStack(spacing: 14) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.textField)

            
            RTLTextField(
                text: $viewModel.query,
                isPasswordVisible: .constant(false),
                placeholder: localizedSearchPlaceholder,
                isSecured: false,
                isRTL: layoutDirection == .rightToLeft,
                textColor: .black.withAlphaComponent(0.6)
            )
            .focused($isSearchFieldFocused)
            .autocorrectionDisabled()
            .submitLabel(.search)
            .bold()
            .frame(height: 30)
     
            
            if !viewModel.query.isEmpty {
                Button {
                    viewModel.clear()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.textField)
                }
            }
        }
        .padding(10)
        .background(.customGray.opacity(0.7), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        
    }
    
    
    @ViewBuilder
    private func content() -> some View {
        switch viewModel.state {
        case .idle:
            emptyState(
                systemImage: "film",
                title: "Search for a movie",
                subtitle: "Find your favorite titles"
            )
            
        case .loading:
            ProgressView()
                .scaleEffect(1.4)
                .tint(.white.opacity(0.8))
                .frame(maxHeight: .infinity)
            
        case .empty:
            emptyState(
                systemImage: "questionmark.folder",
                title: "No results",
                subtitle: "Try a different title"
            )
            
        case .loaded(let movies):
            resultsList(movies)
            
        case .error(_):
            emptyState(
                systemImage: "exclamationmark.triangle",
                title: "Something went wrong",
                subtitle: "Please try again later"
            )
        }
    }
    
    private func resultsList(_ movies: [Movie]) -> some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(movies, id: \.self) { movie in
                    MovieRow(movie: movie)
                        .padding(.horizontal)
                        .onTapGesture {
                            isSearchFieldFocused = false
                            viewModel.clear()
                            router.push(.movieDetails(movie: movie))
                        }
                }
            }
            .padding(.top, 4)
            .padding(.bottom, 120)
        }
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.immediately)
        
    }
    
    private func emptyState(systemImage: String, title: LocalizedStringKey, subtitle: LocalizedStringKey) -> some View {
        VStack(spacing: 9) {
            Image(systemName: systemImage)
                .font(.system(size: 55))
                .foregroundStyle(.white.opacity(0.4))
            Text(title)
                .font(.title3.bold())
                .foregroundStyle(.white.opacity(0.8))
            Text(subtitle)
                .font(.headline)
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    
    private func background() -> some View {
        LinearGradient(
            colors: [.background2, .background],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    
    @ViewBuilder
    private func destinationView(for route: MainRoute) -> some View {
        switch route {
        case .movieDetails(let movie):
            MovieDetailsView(movie: movie)
        case .allMovies(let category):
            AllMoviesView(category: category)
        }
    }

}


#Preview {
    SearchView()
}
