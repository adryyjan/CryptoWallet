//
//  HomeStatsView.swift
//  CryptoWallet
//
//  Created by Adrian Mazek on 31/08/2025.
//

import SwiftUI

struct HomeStatsView: View {
    
    @Environment(HomeVM.self) private var vm
    
    @Binding var showPortfolio: Bool
    var body: some View {
        HStack {
            ForEach(vm.statistics) { stat in
                StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: showPortfolio ? .trailing : .leading)
    }
}

#Preview {
    HomeStatsView(showPortfolio: .constant(false))
        .environment(HomeVM())
}
