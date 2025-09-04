//
//  CoinImageVM.swift
//  CryptoWallet
//
//  Created by Adrian Mazek on 26/08/2025.
//

import SwiftUI
import Combine

@Observable
final class CoinImageVM {
    var image: UIImage?
    var isLoading: Bool = false
    
    private let coin: CoinModel
    private let dataSerivce : CoinImageService
    private var cancellables = Set<AnyCancellable>()
    
    
    init(coin: CoinModel) {
        self.coin = coin
        self.dataSerivce = CoinImageService(coin: coin)
        addSubscribers()
        self.isLoading = true
    }
    
    private func addSubscribers() {
        dataSerivce.$image
            .sink { [weak self] (_) in
                guard let self = self else { return }
                self.isLoading = false
            } receiveValue: { [weak self]( returnedImage) in
                guard let self = self else { return }
                self.image = returnedImage
            }
            .store(in: &cancellables)

    }
}
