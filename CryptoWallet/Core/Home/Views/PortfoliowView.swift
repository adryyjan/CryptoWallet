//
//  PortfoliowView.swift
//  CryptoWallet
//
//  Created by Adrian Mazek on 01/09/2025.
//

import SwiftUI

struct PortfoliowView: View {
    
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckmark: Bool = false
    
    @Environment(HomeVM.self) private var vm
    
    var body: some View {
        @Bindable var vm = vm
        
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    SearchBarView(searchText: $vm.searchText)
                    
                    coinLogoList
                    
                    if selectedCoin != nil {
                        
                        portfolioInput
                        .padding()
                        .font(.headline)
                        .animation(nil, value: 0)
                    }
                    
                    
                }
                .navigationTitle("Edit Portfolio")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        XMarkButton()
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        trailingButton
                        .font(.headline)
                    }
                }
                .onChange(of: vm.searchText) { oldValue, newValue in
                    if newValue.isEmpty {
                        resetSelectedCoin()
                    }
                }
            }
        }
        
        
    }
    
   
}

#Preview {
    PortfoliowView()
}

extension PortfoliowView {
    
    //MARK: - FUNCTIONS
    private func isSelected(_ coin: CoinModel) -> Bool {
        selectedCoin?.id == coin.id
    }
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText)
            
        {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0.0
    }
    
    private func saveButtonPressed() {
        guard let coin = selectedCoin, let amount = Double(quantityText) else { return }
        
        vm.updatePortfolio(coin: coin, ammount: amount)
        
        withAnimation(.easeInOut(duration: 0.2)){
            showCheckmark = true
            resetSelectedCoin()
        }
        
        UIApplication.shared.endEditing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            
            withAnimation {
                showCheckmark = false
            }
        }
        
    }
    
    private func resetSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
    }
    
    private func updateSelectedCoin(coin: CoinModel) {
        selectedCoin = coin
        
        if let portfolioCoin = vm.portfolioCoins.first(where: { $0.id == coin.id }),
            let ammount = portfolioCoin.currentHoldings {
                quantityText = String(ammount)
            }else {
                quantityText = ""
            }
        
    }
    
    //MARK: - EXTENSIONS
    
    private var coinLogoList : some View {
        ScrollView(.horizontal,showsIndicators: false) {
            LazyHStack {
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.filteredCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75, height: 120)
                        .background(Color.theme.background)
                        .clipShape(RoundedRectangle(cornerRadius: 10)
                        )
                        .padding(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(isSelected(coin) ? Color.theme.green : Color.clear, lineWidth: 1)
                        )
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                    
                }
            }
            .padding(.vertical, 4)
            .padding(.leading)
        }
    }
    
    private var portfolioInput : some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Dec() ?? "")
            }
            
            Divider()
            HStack {
                Text("Amount in portfolio:")
                Spacer()
                TextField("Ex: 1.23", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current Value: ")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Dec())
                
            }
        }
    }
    
    private var trailingButton : some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark")
                .opacity(showCheckmark ? 1 : 0)
            Button {
                saveButtonPressed()
            } label: {
                Text("Save".uppercased())
            }
            .opacity(selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText) ? 1 : 0)

            
        }
    }
}
