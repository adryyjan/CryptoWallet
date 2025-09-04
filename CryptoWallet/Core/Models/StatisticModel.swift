//
//  StatisticModel.swift
//  CryptoWallet
//
//  Created by Adrian Mazek on 31/08/2025.
//

import Foundation

struct StatiscticModel: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
    
    static let devStat = StatiscticModel(title: "Dev Stat", value: "12.5 mln", percentageChange: 15.7)
}
