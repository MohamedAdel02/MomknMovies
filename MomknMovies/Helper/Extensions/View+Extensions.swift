//
//  View+Extensions.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 17/08/2026.
//

import SwiftUI
import SkeletonUI

extension View {
    func hideKeyboardOnTap() -> some View {
        self.simultaneousGesture(
            TapGesture().onEnded {
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil, from: nil, for: nil
                )
            }
        )
    }
    
    
    func addSkelton(_ isLoading: Bool = true, shape: ShapeType = .rectangle) -> some View {
        self.skeleton(with: isLoading,
                      animation: .linear(),
                      appearance: .gradient(color: .white.opacity(0.25), background: .white.opacity(0.08)),
                      shape: shape)
    }
    
}
