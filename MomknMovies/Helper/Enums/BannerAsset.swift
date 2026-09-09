//
//  BannerAsset.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 05/09/2026.
//

import SwiftUI

enum BannerAsset {

    static let arabicImages: [ImageResource] = [.banner1Ar, .banner2Ar, .banner3Ar, .banner4Ar]
    static let englishImages: [ImageResource] = [.banner1En, .banner2En, .banner3En, .banner4En]

    static var images: [ImageResource] {
        let isArabic = (UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en") == "ar"
        return isArabic ? arabicImages : englishImages
    }
}
