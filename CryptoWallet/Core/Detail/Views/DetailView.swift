//
//  DetailView.swift
//  CryptoWallet
//
//  Created by Adrian Mazek on 04/09/2025.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: CoinModel?
    

    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
        
    }
}


struct DetailView: View {
    
    @State private var detailsVM : DetailVM
    
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        _detailsVM = State(wrappedValue: DetailVM(coin: coin))
    }
    
    var body: some View {
        Text(coin.name)
        
    }
}

#Preview {
    DetailView(coin: CoinModel.coin)
}
