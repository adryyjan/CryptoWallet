//
//  DetailVM.swift
//  CryptoWallet
//
//  Created by Adrian Mazek on 04/09/2025.
//

import Foundation
import Observation
import Combine

@Observable
final class DetailVM {
    
    private let coinDetailsDS : CoinDetailDataService
    private var cancelabels : [AnyCancellable] = []
    
    init(coin:CoinModel) {
        self.coinDetailsDS = CoinDetailDataService(coin: coin)
    }
    
    private func addSubscribers() {
        coinDetailsDS.$coinDetails
            .sink { returnedCOinDetails in
                print(returnedCOinDetails)
            }
            .store(in: &cancelabels)
    }
    
}
