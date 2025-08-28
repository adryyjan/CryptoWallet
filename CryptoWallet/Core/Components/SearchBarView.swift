//
//  SearchBarView.swift
//  CryptoWallet
//
//  Created by Adrian Mazek on 28/08/2025.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.theme.secoundaryText)
                .foregroundStyle(
                    searchText.isEmpty ? Color.theme.secoundaryText : Color.theme.accent
                )
            TextField("Search by name or symbol...", text: $searchText)
                .foregroundStyle(Color.theme.accent)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .font(.subheadline)
                        .padding()
                        .offset(x: 10)
                        .foregroundStyle(Color.theme.accent)
                        .autocorrectionDisabled(true)
                        
                        .opacity(searchText.isEmpty ? 0 : 1)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            searchText = ""
                        }
                    ,alignment: .trailing
                )
        }
        .font(.caption)
        .padding()
        .background(RoundedRectangle(cornerRadius: 25)
            .fill(Color.theme.background)
            .shadow(color: Color.theme.accent.opacity(0.15), radius: 10))
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
}

#Preview {
    SearchBarView(searchText: .constant("scasdas"))
}
