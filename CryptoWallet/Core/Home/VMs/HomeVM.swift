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
    var filteredCoins: [CoinModel] = []
    var searchText: String = "" { didSet { applyFilter() } }
    
    var statistics: [StatiscticModel] = [
        StatiscticModel(title: "Title1", value: "111", percentageChange: 21),
        StatiscticModel(title: "Title2", value: "222"),
        StatiscticModel(title: "Title3", value: "333"),
        StatiscticModel(title: "Title4", value: "444", percentageChange: -32)
    ]

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
