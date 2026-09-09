//
//  MovieCardStyle.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 05/09/2026.
//

import SwiftUI

enum MovieCardStyle {
    case vertical
    case horizontal
    
    func size(for geometry: GeometryProxy) -> CGSize {
        switch self {
        case .vertical:
            return CGSize(width: geometry.size.width * 0.28, height: geometry.size.height * 0.19)
        case .horizontal:
            return CGSize(width: geometry.size.width * 0.65, height: geometry.size.height * 0.17)
        }
    }
}
