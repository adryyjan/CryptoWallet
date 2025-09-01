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
    
    var statistics: [StatiscticModel] = []

    private let dataService = CoinDataService()
    private let marketService = MarketDataService()
    private var cancellables: Set<AnyCancellable> = []

    init() {
        dataService.$allCoins
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coins in
                guard let self  = self else { return }
                self.allCoins = coins
                self.applyFilter()
            }
            .store(in: &cancellables)
        
        marketService.$marketData
            .receive(on: DispatchQueue.main)
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedStats in
                guard let self = self else { return }
                self.statistics = returnedStats
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
    
    private func mapGlobalMarketData(marketData: MarketDataModel?) -> [StatiscticModel] {
        var stats: [StatiscticModel] = []
        guard let data = marketData else { return stats }
        
        let marketCap = StatiscticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        
        let volume = StatiscticModel(title: "24H Value", value: data.value)
        
        let btcDominance = StatiscticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolio = StatiscticModel(title: "PortfolioValue", value: "00.00", percentageChange: -13.03)
        
        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
        
        return stats
    }
}
