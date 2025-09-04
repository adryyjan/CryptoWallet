//
//  CoinRowView.swift
//  CryptoWallet
//
//  Created by Adrian Mazek on 24/08/2025.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: CoinModel
    let showHoldingsColumn: Bool
    var body: some View {
        HStack(spacing: 0.0) {
            
            leftColumn
            
            Spacer()
            
            if showHoldingsColumn
            {
                middleColumn
            }
            
            rightColumn
            
        }
        .font(.subheadline)
    }
}

#Preview {
    CoinRowView(coin: CoinModel.coin, showHoldingsColumn: true)
}

extension CoinRowView {
    private var leftColumn: some View {
        HStack {
            Text(String(coin.rang))
                .font(.caption)
                .foregroundStyle(Color.theme.secoundaryText)
                .frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text(String(coin.symbol.uppercased()))
                .padding(.leading, 5)
                .foregroundStyle(Color.theme.accent)
        }
    }
    
    private var middleColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Dec())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundStyle(Color.theme.accent)
    }
    
    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith6Dec())
                .bold()
                .foregroundStyle(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "0.0" )
                .foregroundStyle( coin.priceChangePercentage24H  ?? 0 >= 0 ? Color.theme.green : Color.theme.red)
        }
        .frame(width: UIScreen.main.bounds.width / 3.5)
        
    }
}
