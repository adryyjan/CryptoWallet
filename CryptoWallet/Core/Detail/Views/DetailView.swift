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
    
    @StateObject private var detailsVM : DetailVM
    private let columns : [GridItem] = [
        GridItem(.flexible(minimum: 0, maximum: .infinity)),
        GridItem(.flexible(minimum: 0, maximum: .infinity))
    ]
    private var spacing: CGFloat = 20
    
    init(coin: CoinModel) {
        _detailsVM = StateObject(wrappedValue: DetailVM(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: spacing) {
                Text("")
                    .frame(height: 150)
                
                overwiewSecton
                Divider()
                overviewGrid
               
                descriptionSection
                Divider()
                additionaGrid
 
            }
        }
        .padding()
        .navigationTitle(detailsVM.coin.name)
    }
}

#Preview {
    NavigationView {
        DetailView(coin: CoinModel.coin)
    }
}

extension DetailView {
    
    private var overwiewSecton: some View {
        Text("Overwiew")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
       
    }
    
    private var descriptionSection: some View {
        Text("Details")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
        
    }
    
    private var overviewGrid: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: spacing) {
            ForEach(detailsVM.overviewStatictics) { stat in
                StatisticView(stat: stat)
            }
        }
    }
    
    private var additionaGrid: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: spacing) {
            ForEach(detailsVM.addidtionalStatictics) { stat in
                StatisticView(stat: stat)
                
            }
        }
    }
    
    
}
