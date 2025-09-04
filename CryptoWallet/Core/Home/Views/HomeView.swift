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
    @Environment(HomeVM.self) private var vm
    var body: some View {
        @Bindable var vm = vm
        
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
                
            
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
                    portfolioCoins
                        .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: 0)
            }
            .sheet(isPresented: $showPortfolioSheet, content: {
                PortfoliowView()
                    .environment(vm)
            })
            
        }
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
            }
        }
        .listStyle(PlainListStyle())
    }
    private var portfolioCoins: some View {
        List{
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var columnTitles: some View {
        HStack {
            Text("Coin")
            Spacer()
            if showPortfolio {
                Text("Holdings")
                    .transition(.move(edge: .leading))
                    
            }
            
            Text("Price")
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
}
