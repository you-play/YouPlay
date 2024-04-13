//
//  HomeLoadingView.swift
//  YouPlay
//
//  Created by Sebastian on 4/13/24.
//

import SwiftUI

struct HomeLoadingView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
                .frame(height: 200)

            // logo
            Image("YouPlayLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding(.bottom, 32)

            Spacer()

            Color.black.opacity(1)
            ProgressView()
        }
    }
}

#Preview {
    HomeLoadingView()
}
