//
//  HomeVM.swift
//  CryptoWallet
//
//  Created by Adrian Mazek on 24/08/2025.
//

import SwiftUI
import Combine

@Observable
final class HomeVM {
    
    var allCoins: [CoinModel] = []
    var portfolioCoins: [CoinModel] = []
    var searchText: String = ""
    private let dataService = CoinDataService()
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        addSubscription()
    }
    
    func addSubscription() {
        dataService.$allCoins
            .sink { [weak self] (returnedCoins) in
                guard let self = self else { return }
                self.allCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
}
