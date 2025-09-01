//
//  MarketDataService.swift
//  CryptoWallet
//
//  Created by Adrian Mazek on 31/08/2025.
//

import Foundation
import Combine

final class MarketDataService {
    
    @Published var marketData: MarketDataModel? = nil
    var marketDataSubscription: AnyCancellable?
    let networkMenagar = NetworkingMenager.shared
    
    init(){
        getData()
    }
    
    private func getData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        marketDataSubscription = networkMenagar.download(with: url)
            .decode(type: GlobalMarketData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: networkMenagar.handleComplition,
                  receiveValue: { [weak self] (returnedGlobalData) in
                guard let self = self else { return }
                self.marketData = returnedGlobalData.data
                self.marketDataSubscription?.cancel()
            })
        //            .store(in: &coinsSubscription)
    }
    
}
