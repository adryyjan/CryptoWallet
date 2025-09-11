//
//  HomeView.swift
//  CryptoWallet
//
//  Created by Adrian Mazek on 21/08/2025.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showPortfolio: Bool = false
    @State private var showPortfolioSheet: Bool = false
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailsView: Bool = false
    @State private var showSettingsView: Bool = false
    
    @Environment(HomeVM.self) private var vm
    
    var body: some View {
        @Bindable var vm = vm
        
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showSettingsView) {
                    SettingsView()
                }
            VStack {
                
                HomeHeader
                
                HomeStatsView(showPortfolio: $showPortfolio)
                
                SearchBarView(searchText: $vm.searchText)
                
                columnTitles
                    .font(.caption)
                    .foregroundStyle(Color.theme.secoundaryText)
                    .padding(.horizontal)
                if !showPortfolio {
                    allCoins
                        .transition(.move(edge: .leading))
                }
                if showPortfolio {
                    ZStack(alignment: .top) {
                        if vm.portfolioCoins.isEmpty && vm.searchText.isEmpty{
                            portfolioMessage
                        }else{
                            portfolioCoins
                                .transition(.move(edge: .trailing))
                        }
                    }
                    
                }
                
                Spacer(minLength: 0)
            }
            .sheet(isPresented: $showPortfolioSheet, content: {
                PortfoliowView()
                    .environment(vm)
            })
            
        }
        .background(NavigationLink(isActive: $showDetailsView, destination: {
            DetailLoadingView(coin: $selectedCoin)
        }, label: {
            EmptyView()
        }))
    }
}

#Preview {
    HomeView()
        .environment(HomeVM())
}


extension HomeView {
    
    private var HomeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(nil ,value: 0)
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioSheet.toggle()
                    }else{
                        showSettingsView.toggle()
                    }
                }
                .background(CircleButtonAnimationView(isAnimating: $showPortfolio))
            Spacer()
            Text( showPortfolio ? "Portfolio" : "Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(Color.theme.accent)
                .animation(nil ,value: 0)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
    }
    
    private var allCoins: some View {
        List{
            ForEach(vm.filteredCoins) { coin in
                    CoinRowView(coin: coin, showHoldingsColumn: false)
                        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                        .onTapGesture {
                            segue(coin: coin)
                        }
                        .listRowBackground(Color.clear)
                
                
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private func segue(coin: CoinModel) {
        selectedCoin = coin
        showDetailsView.toggle()
    }
    private var portfolioCoins: some View {
        List{
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var columnTitles: some View {
        HStack {
            HStack(spacing: 4.0) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity(vm.isSorted(option1: .rank, option2: .rankReverse) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .rank ? .rankReverse : .rank
                }
            }
            Spacer()
            if showPortfolio {
                HStack(spacing: 4.0) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity(vm.isSorted(option1: .holdings, option2: .holdingReverse) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        vm.sortOption = vm.sortOption == .holdings ? .holdingReverse: .holdings
                    }
                }
                .transition(.move(edge: .leading))
                
            }
            
            HStack(spacing: 4.0) {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity(vm.isSorted(option1: .price, option2: .priceReverse) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .price ? .priceReverse : .price
                }
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            
            Button {
                withAnimation(.spring()) {
                    vm.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(Angle(degrees: vm.isDataLoading ? 360 : 0), anchor: .center)
        }
    }
    
    private var portfolioMessage: some View {
        VStack {
            Text("You dont have any coins in your portfolio YET 😄")
            Text("Click + button to get started 🥳")
        }
        .font(.callout)
        .foregroundStyle(Color.theme.accent)
        .fontWeight(.medium)
        .multilineTextAlignment(.center)
        .padding(50)
    }
    
}
