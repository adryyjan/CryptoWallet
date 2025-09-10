//
//  SettingsView.swift
//  CryptoWallet
//
//  Created by Adrian Mazek on 07/09/2025.
//

import SwiftUI

struct SettingsView: View {
    
    let defoultURl = URL(string: "https://www.google.com")
    let githubURL = URL(string: "https://github.com/adryyjan")!
    let coingeckoURL = URL(string: "https://www.coingecko.com")
    
    var body: some View {
        NavigationStack{
            List {
                aboutMe
                
                coinGekko
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    XMarkButton()
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}

extension SettingsView {
    private var aboutMe: some View {
        Section(header: Text("About")) {
            VStack(alignment: .leading, spacing: 10.0) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                
                }
            VStack(alignment: .leading, spacing: 10.0) {
                Text("Project made by Adrian Mazek as end result of yt Swiftfull Thinking course 🥳")
                Text("Archtecture based on MVVM")
                Text("Data handling using Combine and CoreData")
            }
            
            Link(destination: githubURL) {
                Text("My GitHub ❤️")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
                
            }
        }
    }
    
    private var coinGekko: some View {
        Section(header: Text("Data Provider")) {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                
            }
            VStack(alignment: .leading, spacing: 10.0) {
                Text("Crypto data provider is CoinGecko API")
            }
            Link(destination: coingeckoURL!) {
                Text("Visit CoinGecko API page 🔗")
            }
        }
    }
}
