//
//  DetailVM.swift
//  CryptoWallet
//
//  Created by Adrian Mazek on 04/09/2025.
//

import Foundation
import Observation
import Combine


final class DetailVM: ObservableObject {
    
    @Published var overviewStatictics: [StatiscticModel] = []
    @Published var addidtionalStatictics: [StatiscticModel] = []
    @Published var coinDescription : String? = nil
    @Published var websiteURL : String? = nil
    @Published var reddditURL : String? = nil
    
    
    @Published var coin: CoinModel
    private let coinDetailsDS : CoinDetailDataService
    private var cancelabels : [AnyCancellable] = []
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailsDS = CoinDetailDataService(coin: coin)
        addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailsDS.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistic)
            .sink { [weak self] returnedArrays in
                guard let self = self else { return }
                
                self.overviewStatictics = returnedArrays.overwiew
                self.addidtionalStatictics = returnedArrays.additionl
            }
            .store(in: &cancelabels)
        
        coinDetailsDS.$coinDetails
            .sink { [weak self] returnedCoinDetail in
                guard let self = self else { return }
                self.coinDescription = returnedCoinDetail?.description?.en
                self.websiteURL = returnedCoinDetail?.links?.homepage?.first
                self.reddditURL = returnedCoinDetail?.links?.subredditURL
            }
            .store(in: &cancelabels)
    }
    
    private func mapDataToStatistic(coinDetail: CoinDetailsModel?, coinModel: CoinModel) -> (overwiew: [StatiscticModel], additionl: [StatiscticModel]) {
        
//        overview
        let price = coinModel.currentPrice.asCurrencyWith6Dec()
        let pricePercentageChanged = coinModel.priceChangePercentage24H
        let priceStats = StatiscticModel(title: "Current Value", value: price, percentageChange: pricePercentageChanged)
        
        let marketCap = coinModel.marketCap?.formattedWithAbbreviations() ?? "0.0"
        let marketCapPercentageCHange = coinModel.marketCapChangePercentage24H
        let marketCapStats = StatiscticModel(title: "Market Cap", value: marketCap, percentageChange: marketCapPercentageCHange)
        
        let rank = String(coinModel.rang)
        let rankStat = StatiscticModel(title: "Rank", value: rank)
        
        let volume = coinModel.totalVolume?.formattedWithAbbreviations() ?? "0.0"
        let volumeStat = StatiscticModel(title: "Volume", value: volume)
        
        let overwiewArray : [StatiscticModel] = [priceStats,marketCapStats,rankStat,volumeStat]
        
        //                additional
        let high = coinModel.high24H?.asCurrencyWith6Dec() ?? "n/e"
        let highStat = StatiscticModel(title: "High 24h", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith6Dec() ?? "n/e"
        let lowStat = StatiscticModel(title: "Low 24h", value: low)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Dec() ?? "n/e"
        let pricePercentageChanged2 = coinModel.priceChangePercentage24H
        let priceChangeStats = StatiscticModel(title: "Price Change 24h", value: priceChange, percentageChange: pricePercentageChanged2)
        
        let marketCapChange = coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? ""
        let marketCapPercentageChange2 = coinModel.marketCapChangePercentage24H
        let marketCapChangeStats = StatiscticModel(title: "Market Cap Change 24h", value: marketCapChange, percentageChange: marketCapPercentageChange2)
        
        let blockTime = coinDetail?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockTimeStat = StatiscticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetail?.hashingAlgorithm ?? "n/a"
        let hashStat = StatiscticModel(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray = [highStat,lowStat,priceChangeStats,marketCapChangeStats,blockTimeStat, hashStat]
        
        
        return (overwiewArray,additionalArray)
    }
    
}
