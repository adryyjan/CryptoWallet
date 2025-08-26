//
//  CoinageService.swift
//  CryptoWallet
//
//  Created by Adrian Mazek on 26/08/2025.
//

import SwiftUI
import Combine

final class CoinImageService {
    
    @Published var image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    let networkMenagar = NetworkingMenager.shared
    private let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        
        getCoinImage()
    }
    
    private func getCoinImage() {
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscription = networkMenagar.download(with: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: networkMenagar.handleComplition,
                  receiveValue: { [weak self] (returnImage) in
                guard let self = self else { return }
                self.image = returnImage
                self.imageSubscription?.cancel()
            })
        //            .store(in: &coinsSubscription)
    }
}
