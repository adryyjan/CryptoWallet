//
//  HomeVM.swift
//  CryptoWallet
//
//  Created by Adrian Mazek on 24/08/2025.
//

import SwiftUI
import Combine

//@Observable
//final class HomeVM {
//    
//    var allCoins: [CoinModel] = []
//    var portfolioCoins: [CoinModel] = []
//    var searchText: String = ""
//    private let dataService = CoinDataService()
//    private var cancellables: Set<AnyCancellable> = []
//    
//    init() {
//        addSubscription()
//    }
//    
//    func addSubscription() {
//        dataService.$allCoins
//            .sink { [weak self] (returnedCoins) in
//                guard let self = self else { return }
//                self.allCoins = returnedCoins
//            }
//            .store(in: &cancellables)
//    }
//    
//}



@Observable

final class HomeVM {
    var allCoins: [CoinModel] = []
    var portfolioCoins: [CoinModel] = []
    var filteredCoins: [CoinModel] = []
    var searchText: String = "" { didSet { applyFilter() } }

    private let dataService = CoinDataService()
    private var cancellables: Set<AnyCancellable> = []

    init() {
        dataService.$allCoins
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coins in
                guard let self else { return }
                self.allCoins = coins
                self.applyFilter()
            }
            .store(in: &cancellables)
    }

    private func applyFilter() {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !q.isEmpty else {
            filteredCoins = allCoins
            return
        }
        filteredCoins = allCoins.filter { coin in
            coin.name.lowercased().contains(q)
            || coin.symbol.lowercased().contains(q)
            || coin.id.lowercased().contains(q)
        }
    }
}
