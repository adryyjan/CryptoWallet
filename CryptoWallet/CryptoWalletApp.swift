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
    @State private var showLaunchScreen = true
    
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UITableView.appearance().backgroundColor = UIColor(Color.clear)
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationStack(path: $path) {
                    HomeView()
                        .navigationBarBackButtonHidden(true)
                }
                .environment(homeVM)

                ZStack {
                    if showLaunchScreen {
                        LaunchView(showLaunchScreen: $showLaunchScreen)
                            .transition(.move(edge: .leading))
                            
                    }
                }
                .zIndex(2.0)
                
            }
        }
    }
}
