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
    init(){
        getCoins()
    }
    
    private func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }
        
        coinsSubscription = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { (output) -> Data in
                guard let resposnse = output.response as? HTTPURLResponse, resposnse.statusCode >= 200 && resposnse.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink { (complition) in
                switch complition {
                    case .failure(let error):
                    print("Error: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] (returnedCoins) in
                guard let self = self else { return }
                self.allCoins = returnedCoins
                self.coinsSubscription?.cancel()
            }
//            .store(in: &coinsSubscription)
    }
    
}
