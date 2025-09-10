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
    @State private var showFullDesc: Bool = false
    
    init(coin: CoinModel) {
        _detailsVM = StateObject(wrappedValue: DetailVM(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ChartView(coin: detailsVM.coin)
                    .padding(.vertical)
            }
            VStack(spacing: spacing) {
                
                
                overwiewSecton
                Divider()
                
                descryptionSection
                overviewGrid
               
                descriptionSection
                Divider()
                additionaGrid
                
                LinkSection
 
            }
            .padding()
        }
        
        .navigationTitle(detailsVM.coin.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                navigationBarTrailingItem
            }
        }
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
    
    private var navigationBarTrailingItem: some View {
        HStack {
            Text(detailsVM.coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.secoundaryText)
            CoinImageView(coin: detailsVM.coin)
                .frame(width: 25,height: 25)
        }
    }
    
    private var descryptionSection: some View {
        ZStack {
            if let coinDescription = detailsVM.coinDescription, !coinDescription.isEmpty {
                VStack {
                    Text(coinDescription)
                        .lineLimit(showFullDesc ? nil : 3)
                        .font(.callout)
                        .foregroundStyle(Color.theme.secoundaryText)
                    
                    Button {
                        withAnimation(.easeInOut) {
                            showFullDesc.toggle()
                        }
                    } label: {
                        Text(showFullDesc ? "Show less..." : "Read more...")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    }

                }
                
            }
        }
    }
    
    private var LinkSection: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            if let website = detailsVM.websiteURL, let urlWebsite = URL(string: website) {
                Link("Website", destination: urlWebsite)
            }
            if let reddit = detailsVM.reddditURL, let urlReddit = URL(string: reddit) {
                Link("Reddit", destination: urlReddit)
            }
        }
        .foregroundStyle(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
    
    
}
