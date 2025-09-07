//
//  CoinDetailService.swift
//  CryptoWallet
//
//  Created by Adrian Mazek on 04/09/2025.
//
import Foundation
import Combine


final class CoinDetailDataService {
    
    let coin: CoinModel
    
    @Published var coinDetails: CoinDetailsModel? = nil
    var coinDetailSubscription: AnyCancellable?
    let networkMenagar = NetworkingMenager.shared
    
    init(coin: CoinModel){
        self.coin = coin
        getCoins()
    }
    
    private func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }
        
        coinDetailSubscription = networkMenagar.download(with: url)
            .decode(type: CoinDetailsModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: networkMenagar.handleComplition,
                  receiveValue: { [weak self] (returnedCoinDetails) in
                guard let self = self else { return }
                self.coinDetails = returnedCoinDetails
                self.coinDetailSubscription?.cancel()
            })
        //            .store(in: &coinsSubscription)
    }
    
    func reloadCoinData() {
        getCoins()
    }
    
}
