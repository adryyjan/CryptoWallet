//
//  CircleButtonAnimationView.swift
//  CryptoWallet
//
//  Created by Adrian Mazek on 21/08/2025.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    
    @Binding var isAnimating: Bool
    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(isAnimating ? 1.0 : 0.5)
            .opacity(isAnimating ? 0.0 : 1.0)
            .animation(isAnimating ? .easeOut(duration: 0.5) : nil,
                   value: isAnimating)

    }
}


