//
//  EmptyContentView.swift
//  YouPlay
//
//  Created by Sebastian on 4/13/24.
//

import SwiftUI

struct HomeEmptyContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            ContentUnavailableView(
                "Nothing here yet!",
                systemImage: "music.mic.circle.fill",
                description: Text("Start searching for songs and creating playlists")
            )

            Spacer()
        }
        .frame(height: UIScreen.main.bounds.height / 1.3)
    }
}

#Preview {
    HomeEmptyContentView()
}
