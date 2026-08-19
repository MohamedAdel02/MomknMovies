//
//  MainAuthView.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 17/08/2026.
//

import SwiftUI

enum AuthMode {
    case login
    case signUp
}

struct MainAuthView: View {
    
    @State var viewModel = MainAuthViewModel()
    @State var authMode: AuthMode = .login
    
    @Environment(Router.self) private var router
    
    var body: some View {
        
        @Bindable var router = router
        
        NavigationStack(path: $router.path) {
            GeometryReader { geo in
                
                VStack(spacing: 15) {
                    
                    ZStack {
                        
                        Image(viewModel.images[viewModel.index])
                            .resizable()
                            .padding(.bottom, authMode == .signUp ? bottomPadding(for: viewModel.images[viewModel.index]) : 0)
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: authMode == .login ? geo.size.height * 0.63 : geo.size.height * 0.43)
                            .clipped()
                            .transition(.move(edge: .trailing))
                            .animation(.spring(duration: 3.5), value: viewModel.index)
                            .animation(.easeInOut(duration: 0.6), value: authMode)
                        
                        VStack {
                            Spacer()
                            
                            LinearGradient(
                                colors: [.clear, .background],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(height: authMode == .login ? geo.size.height * 0.2 : geo.size.height * 0.1)
                            .animation(.easeInOut(duration: 0.6), value: authMode)
                        }
                    }
                    .frame(height: authMode == .login ? geo.size.height * 0.63 : geo.size.height * 0.43)
                    
                    ScrollView {
                        Group {
                            switch authMode {
                            case .login:
                                LoginView(authMode: $authMode)
                                    .transition(.opacity)
                            case .signUp:
                                CreateAccountView(authMode: $authMode)
                                    .transition(.opacity)
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    
                }
                .background(Color.background)
                .ignoresSafeArea(edges: .top)
                .contentShape(Rectangle())
                .hideKeyboardOnTap()
                .navigationDestination(for: Route.self) { route in
                    destination(for: route)
                }
                .onAppear {
                    viewModel.startTimer()
                }
                .onDisappear {
                    viewModel.stopTimer()
                }
                
            }
        }
    }
    
    @ViewBuilder
    func destination(for route: Route) -> some View {
        switch route {
        case .forgetPassword:
            ForgetPasswordView()
        }
    }
    
    private func bottomPadding(for image: ImageResource) -> CGFloat {
        switch image {
        case .dunkirk: return -100
        case .onceUponTimeInHollywood: return -200
        case .tenet: return -250
        case .goneGirl: return 100
        default: return 0
        }
    }
}


#Preview {
    MainAuthView()
}

