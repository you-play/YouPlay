//
//  HomeView.swift
//  YouPlay
//
//  Created by Sebastian on 3/13/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @ObservedObject var spotifyController: SpotifyController

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
                                PlaylistDetailView(
                                    playlist: playlist,
                                    songs: viewModel.fetchSongsForPlaylist(playlistId: playlist.id),
                                    spotifyController: spotifyController
                                )
                            } label: {
                                PlaylistCardView(playlist: playlist)
                            }
                            .tint(.white)
                        }
                    }
                    .padding(.horizontal)

                    ScrollableSongsView(
                        title: "Recommended",
                        songs: Song.mocks,
                        spotifyController: spotifyController
                    )

                    ScrollableSongsView(
                        title: "Latest",
                        songs: Song.mocks,
                        spotifyController: spotifyController
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
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(), spotifyController: SpotifyController())
}
