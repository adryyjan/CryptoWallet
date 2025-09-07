//
//  Date.swift
//  CryptoWallet
//
//  Created by Adrian Mazek on 06/09/2025.
//

import Foundation

extension Date {
    
    init(coinGekoString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: coinGekoString) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    private var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    func asShortDateString() -> String {
        return shortFormatter.string(from: self)
    }
    
}
