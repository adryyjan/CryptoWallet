//
//  MarketDataModel.swift
//  CryptoWallet
//
//  Created by Adrian Mazek on 31/08/2025.
//

import Foundation

struct GlobalMarketData: Codable {
    let data: MarketDataModel?
}

struct MarketDataModel: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
    
    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    var marketCap: String {
        if let item = totalMarketCap["usd"] {
            return String(item.formattedWithAbbreviations())
        }
        return ""
    }
    
    var value: String {
        if let item = totalVolume["usd"] {
            return String(item.formattedWithAbbreviations())
        }
        return ""
    }
    
    var btcDominance: String {
        if let item = marketCapPercentage["btc"] {
            return item.asPercentString()
        }
        return ""
    }
    
}
