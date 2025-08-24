//
//  HomeVM.swift
//  CryptoWallet
//
//  Created by Adrian Mazek on 24/08/2025.
//

import SwiftUI

@Observable
final class HomeVM {
    
    var allCoins: [CoinModel] = []
    var portfolioCoins: [CoinModel] = []
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.allCoins.append(CoinModel.coin)
            self.portfolioCoins.append(CoinModel.coin)
        }
    }
}
