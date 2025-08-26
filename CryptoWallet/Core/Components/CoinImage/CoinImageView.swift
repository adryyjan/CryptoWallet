//
//  CoinImageView.swift
//  CryptoWallet
//
//  Created by Adrian Mazek on 26/08/2025.
//

import SwiftUI



struct CoinImageView: View {
    
    @State var coinImageVM : CoinImageVM
    
    init(coin: CoinModel) {
        _coinImageVM = State(wrappedValue: CoinImageVM(coin: coin))
    }
    
    var body: some View {
        ZStack{
            if let image = coinImageVM.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if coinImageVM.isLoading {
                ProgressView()
            }else{
                Image(systemName: "questionmark.app.dashed")
                    .foregroundStyle(Color.theme.accent)
            }
        }
    }
}

#Preview {
    CoinImageView(coin: CoinModel.coin)
}
