//
//  LaunchView.swift
//  CryptoWallet
//
//  Created by Adrian Mazek on 09/09/2025.
//

import SwiftUI

struct LaunchView: View {
    
    @State private var loadingText: [String] = "Loading...".map { String($0)}
    @State private var showLoadingText: Bool = false
    private var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var timeCount = 0
    @State private var loopIteration = 0
    @Binding var showLaunchScreen: Bool
    
    init(showLaunchScreen: Binding<Bool>) {
            self._showLaunchScreen = showLaunchScreen
        }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            Image("logo-transparent")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
//                .offset(y: -50)
            
            ZStack {
                if showLoadingText {
                    HStack {
                        ForEach(loadingText.indices) { index in
                            Text(loadingText[index])
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundStyle(Color.launchTheme.accent)
                                .offset(y: timeCount == index ? -5 : 0)
                        }
                    }
                    .transition(AnyTransition.scale.animation(.easeIn))
                }
                
                    
            }
            .offset(y: 70)
        }
        .onAppear{
            showLoadingText.toggle()
        }
        .onReceive(timer) { _ in
            if timeCount == loadingText.count - 1 {
                timeCount = 0
                loopIteration += 1
                if loopIteration >= 2 {
                    showLaunchScreen = false
                }
            } else {
                timeCount += 1
            }
            
        }
    }
}

//#Preview {
//    LaunchView()
//}
