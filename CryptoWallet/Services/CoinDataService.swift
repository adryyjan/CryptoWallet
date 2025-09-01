//
//  CoinDataService.swift
//  CryptoWallet
//
//  Created by Adrian Mazek on 25/08/2025.
//

import Foundation
import Combine


final class CoinDataService {
    
    @Published var allCoins: [CoinModel] = []
    var coinsSubscription: AnyCancellable?
    let networkMenagar = NetworkingMenager.shared
    
    init(){
        getCoins()
    }
    
    private func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1&sparkline=true&price_change_percentage=24h") else { return }
        
        coinsSubscription = networkMenagar.download(with: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: networkMenagar.handleComplition,
                  receiveValue: { [weak self] (returnedCoins) in
                guard let self = self else { return }
                self.allCoins = returnedCoins
                self.coinsSubscription?.cancel()
            })
        //            .store(in: &coinsSubscription)
    }
    
}
