//
//  AssetView.swift
//  MyAssets
//
//  Created by 김초원 on 2023/01/17.
//

import SwiftUI

struct AssetView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    Spacer()
                    AssetMenuGridView()
                    AssetBannerView()
                        .aspectRatio(5/2, contentMode: .fit)
//                    AssetSummaryView()
//                        .environmentObject(AssetSummaryData())
                }
            }
            .background(Color.gray.opacity(0.2))
            .navigaionBarWithButtonStyle("내 자산")
        }
    }
}

struct AssetView_Previews: PreviewProvider {
    static var previews: some View {
        AssetView()
    }
}
