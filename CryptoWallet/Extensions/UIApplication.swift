//
//  UIApplication.swift
//  CryptoWallet
//
//  Created by Adrian Mazek on 28/08/2025.
//

import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
