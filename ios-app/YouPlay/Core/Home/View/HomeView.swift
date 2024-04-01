//
//  HomeView.swift
//  YouPlay
//
//  Created by Sebastian on 3/13/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(spacing: 16) {
                    ScrollableSongsView(
                        title: "Recommended",
                        songs: Song.mocks
                    )

                    ScrollableSongsView(
                        title: "Latest",
                        songs: Song.mocks
                    )
                }
            }
        }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel())
}
