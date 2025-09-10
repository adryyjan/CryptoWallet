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
    private let fileMenager = LocalFileMenager.shared
    private let folderName = "coin_images"
    private let imageName: String
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage() {
        if let savedImage = fileMenager.getImage(imageName: imageName, folderName: folderName) {
            self.image = savedImage
        } else{
            downloadCoinImage()
        }
    }
    
    private func downloadCoinImage() {
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscription = networkMenagar.download(with: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkMenagar.handleComplition,
                  receiveValue: { [weak self] (returnImage) in
                guard let self = self, let dowloadedImage = returnImage else { return }
                self.image = dowloadedImage
                self.imageSubscription?.cancel()
                self.fileMenager.saveImage(image: dowloadedImage, imageName: imageName, folderName: folderName)
                print("Downloaded")
            })
        //            .store(in: &coinsSubscription)
    }
}
