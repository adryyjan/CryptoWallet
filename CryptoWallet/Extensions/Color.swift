//
//  Color.swift
//  CryptoWallet
//
//  Created by Adrian Mazek on 21/08/2025.
//

import SwiftUI

extension Color {
    static let theme = ColorTheme()
    static let launchTheme = LaunchTeheme()
}

struct ColorTheme {
     let accent = Color("AccentColor")
     let background = Color("BackgroundColor")
     let green = Color("GreenColor")
     let red = Color("RedColor")
     let secoundaryText = Color("SecondaryTextColor")
}

struct LaunchTeheme {
    
    let backgroung = Color("LaunchBackgroungColor")
    let accent = Color("LaunchAccentColor")
}
