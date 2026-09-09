//
//  MainAuthViewModel.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 17/08/2026.
//

import SwiftUI

@Observable
class MainAuthViewModel {
    
    var index = 0
    let images: [ImageResource] = [.laLaLand, .dunkirk, .onceUponTimeInHollywood, .tenet, .batman, .goneGirl]
    
    private var timer: Timer?

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.onTransition()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func onTransition() {
        if index < images.count - 1 {
            index += 1
        } else {
            index = 0
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}


