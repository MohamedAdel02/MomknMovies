//
//  BannerView.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 22/08/2026.
//

import SwiftUI
import SkeletonUI
import Combine

struct BannerView: View {

    private let images = BannerAsset.images
    var isLoading: Bool
    
    @State private var currentPage: Int? = 0
    @State private var autoScrollTask: Task<Void, Never>?

    var body: some View {
        GeometryReader { geometry in
            let cardWidth = geometry.size.width * 0.85
            let spacing: CGFloat = 20

            ZStack(alignment: .bottom) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: spacing) {
                        ForEach(images.indices, id: \.self) { index in

                            if isLoading {

                                skeltonPlaceholder()
                                    .frame(width: cardWidth, height: geometry.size.height)

                            } else {

                                Image(images[index])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: cardWidth, height: geometry.size.height)
                                    .clipped()
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                        }
                    }
                    .scrollTargetLayout()
                }
                .contentMargins(
                    .horizontal,
                    (geometry.size.width - cardWidth) / 2,
                    for: .scrollContent
                )
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $currentPage, anchor: .center)
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { _ in
                            autoScrollTask?.cancel()
                        }
                        .onEnded { _ in
                            scheduleAutoScroll()
                        }
                )
                
                if !isLoading {
                    pageIndicator()
                        .padding(.bottom, 16)
                }
                    
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .onAppear {
            scheduleAutoScroll()
        }
        .onDisappear {
            autoScrollTask?.cancel()
        }
    }
    
    private func scheduleAutoScroll() {
        autoScrollTask?.cancel()

        autoScrollTask = Task {
            try? await Task.sleep(for: .seconds(3))

            guard !Task.isCancelled else { return }

            advancePage()
            scheduleAutoScroll()
        }
    }
    
    private func advancePage() {
        
        var next = (currentPage ?? 0) + 1
        if next == images.count {
            next = 0
        }
        
        withAnimation(.easeInOut(duration: 0.4)) {
            currentPage = next
        }
    }

    private func pageIndicator() -> some View {
        HStack(spacing: 6) {
            ForEach(images.indices, id: \.self) { index in
                Capsule()
                    .fill(index == currentPage ? Color.white : Color.white.opacity(0.4))
                    .frame(width: index == currentPage ? 20 : 6, height: 6)
                    .animation(.easeInOut(duration: 0.2), value: currentPage)
            }
        }
    }
    
    private func skeltonPlaceholder() -> some View {
        
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.white.opacity(0.1))
            .skeleton(
                with: true,
                animation: .linear(),
                appearance: .gradient(
                    color: .white.opacity(0.25),
                    background: .white.opacity(0.08)
                ),
                shape: .rounded(.radius(20, style: .continuous))
            )
        
    }
}

#Preview {
    BannerView(isLoading: false)
        .frame(height: 220)
        .background(Color.black)
}

