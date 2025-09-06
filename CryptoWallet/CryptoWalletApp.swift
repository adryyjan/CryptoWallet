//
//  CryptoWalletApp.swift
//  CryptoWallet
//
//  Created by Adrian Mazek on 21/08/2025.
//

import SwiftUI

@main
struct CryptoWalletApp: App {
    @State private var homeVM = HomeVM()
    @State private var path = NavigationPath()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                HomeView()
                    .navigationBarBackButtonHidden(true)
            }
            .environment(homeVM)
               
        }
    }
}
