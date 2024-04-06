//
//  HomeView.swift
//  YouPlay
//
//  Created by Sebastian on 3/13/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @StateObject var spotifyController = SpotifyController()

    private let gridColumns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
    ]

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(spacing: 16) {
                    // top playlist
                    LazyVGrid(columns: gridColumns, spacing: 8) {
                        ForEach(viewModel.topPlaylists) { playlist in
                            NavigationLink {
                                // TODO: navigate to playlist view
                                Text("Viewing songs for: \(playlist.title)")
                                    .navigationTitle(playlist.title)
                                    .navigationBarTitleDisplayMode(.inline)
                            } label: {
                                PlaylistCardView(playlist: playlist)
                            }
                            .tint(.white)
                        }
                    }
                    .padding(.horizontal)

                    ScrollableSongsView(
                        title: "Recommended",
                        songs: Song.mocks
                    )

                    ScrollableSongsView(
                        title: "Latest",
                        songs: Song.mocks
                    )
                }
                .padding(.top)
                .onAppear {
                    Task {
                        await viewModel.fetchTopPlaylists()
                    }
                }
            }
        }
        .onOpenURL { url in
            spotifyController.setAccessToken(from: url)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didFinishLaunchingNotification), perform: { _ in
            spotifyController.connect()
        })
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel())
}
