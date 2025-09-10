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
    var statistics: [StatiscticModel] = []
    
    var searchText: String = "" { didSet { applyFilter() } }
    var isDataLoading: Bool = false
    var sortOption: SortOption = .holdings {
        didSet { filterAndSortCoins(sort: sortOption, coins: allCoins)
            portfolioCoins = sortPortfolioIfNeeded(coins: portfolioCoins)
        }}
    
    private let dataService = CoinDataService()
    private let marketService = MarketDataService()
    private let portfolioService = PortfolioDataService()
    private let hapticManager = HapticMenager.shared
    
    private var cancellables: Set<AnyCancellable> = []
    
    enum SortOption {
        case rank, rankReverse, holdings, holdingReverse, price, priceReverse
    }
    
    init() {
        dataService.$allCoins
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coins in
                guard let self  = self else { return }
                self.allCoins = coins
                self.applyFilter()
            }
            .store(in: &cancellables)
        
        let portfolioCoinsPublisher = dataService.$allCoins
            .combineLatest(portfolioService.$savedEntities)
            .map { coins, entities -> [CoinModel] in
                coins.compactMap { coin in
                    
                    guard let entity = entities.first(where: { $0.coinID == coin.id }) else { return nil }
                    return coin.updateHoldings(amount: entity.ammount)
                }
            }
            .share()
        
        portfolioCoinsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.portfolioCoins = $0 }
            .store(in: &cancellables)
        
        marketService.$marketData
            .receive(on: DispatchQueue.main)
            .combineLatest(portfolioCoinsPublisher)
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedStats in
                guard let self = self else { return }
                self.statistics = returnedStats
                self.isDataLoading = false
            }
            .store(in: &cancellables)
        
        dataService.$allCoins
            .combineLatest(portfolioService.$savedEntities)
            .map { coinModels, portfolioEntities -> [CoinModel] in
                coinModels.compactMap { coin -> CoinModel? in
                    guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else { return nil }
                    return coin.updateHoldings(amount: entity.ammount)
                }
            }
            .sink { [weak self] portfolioCoins in
                
                self?.portfolioCoins = self!.sortPortfolioIfNeeded(coins: portfolioCoins)
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin: CoinModel, ammount: Double) {
        portfolioService.updatePortfolio(coin: coin, ammount: ammount)
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
    private func filterAndSortCoins(sort: SortOption, coins: [CoinModel]) -> [CoinModel] {
        applyFilter()
        sortCoins(sort: sort, coins: &filteredCoins)
        return filteredCoins
    }
    
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]){
        switch sort {
        case .price:
            coins.sort(by: {$0.currentPrice < $1.currentPrice})
        case .priceReverse:
            coins.sort(by: {$0.currentPrice > $1.currentPrice})
        case .rank:
            coins.sort(by: {$0.rang < $1.rang})
        case .rankReverse:
            coins.sort(by: {$0.rang > $1.rang})
        case .holdings:
            coins.sort(by: {$0.currentHoldings ?? 0.0 < $1.currentHoldings ?? 0.0 })
        case .holdingReverse:
            coins.sort(by: {$0.currentHoldings ?? 0.0  > $1.currentHoldings ?? 0.0 })
            
        }
    }
    
    private func sortPortfolioIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        
        switch sortOption {
        case .holdings:
            return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        case .holdingReverse:
            return coins.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})
        default :
            return coins
        }
    }
    
    func isSorted(option1: SortOption, option2: SortOption) -> Bool {
        return option1 == sortOption || option2 == sortOption
    }
    
    func reloadData() {
        isDataLoading = true
        dataService.reloadCoinData()
        marketService.reloadMarketData()
        hapticManager.notify(type: .success)
        
    }
    
    private func mapGlobalMarketData(marketData: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatiscticModel] {
        var stats: [StatiscticModel] = []
        guard let data = marketData else { return stats }
        
        let marketCap = StatiscticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        
        let volume = StatiscticModel(title: "24H Value", value: data.value)
        
        let btcDominance = StatiscticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue = portfolioCoins
            .map { $0.currentHoldingsValue }
            .reduce(0.0, +)
        
        let previousValue = portfolioCoins.map { coin -> Double in
            let currentValue = coin.currentHoldingsValue
            let percentageChange = (coin.priceChangePercentage24H ?? 0) / 100
            let previousValue = currentValue / (1 + percentageChange)
            
            return previousValue
        }
            .reduce(0.0, +)
        
        let percaentageChange = ((portfolioValue - previousValue) / previousValue)
        
        let portfolio = StatiscticModel(title: "PortfolioValue", value: portfolioValue.asCurrencyWith2Dec(), percentageChange: percaentageChange)
        
        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
        
        return stats
    }
}
