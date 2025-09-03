//
//  HapticMenager.swift
//  CryptoWallet
//
//  Created by Adrian Mazek on 03/09/2025.
//

import SwiftUI

final class HapticMenager {
    
    static let shared = HapticMenager()
    
    private init() {}
    
    private let generator = UINotificationFeedbackGenerator()
    
    func notify(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
    
}
