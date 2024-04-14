//
//  HomeView.swift
//  YouPlay
//
//  Created by Sebastian on 3/13/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @StateObject var playlistViewModel = PlaylistsViewModel()
    @ObservedObject var spotifyController: SpotifyController

    private let gridColumns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
    ]

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                if viewModel.isLoading {
                    HomeLoadingView()
                } else if viewModel.topPlaylists.isEmpty {
                    HomeEmptyContentView()
                } else {
                    VStack(spacing: 16) {
                        // top playlist header
                        LazyVGrid(columns: gridColumns, spacing: 8) {
                            ForEach(viewModel.topPlaylists) { playlist in
                                NavigationLink {
                                    PlaylistDetailView(
                                        playlist: playlist,
                                        songs: viewModel.playlistIdToSongs[playlist.id] ?? [],
                                        spotifyController: spotifyController
                                    )
                                } label: {
                                    PlaylistCardView(playlist: playlist)
                                }
                                .tint(.white)
                            }
                        }
                        .padding(.horizontal)

                        // playlists
                        if viewModel.isLoadingSongMetadata {
                            ForEach(1 ... 4, id: \.self) { _ in
                                SkeletonCardRowView()
                            }
                        } else {
                            ForEach(viewModel.topPlaylists) { playlist in
                                ScrollableSongsView(
                                    title: playlist.title,
                                    songs: viewModel.playlistIdToSongs[playlist.id] ?? [],
                                    spotifyController: spotifyController
                                )
                            }
                        }
                    }
                    .padding(.top)
                    .padding(.bottom, 72)
                }
            }
            .refreshable {
                Task {
                    await viewModel.fetchTopPlaylists(inBackground: true)
                }
            }
        }
        .onAppear {
            Task {
                if viewModel.playlistIdToSongs.isEmpty {
                    await viewModel.fetchTopPlaylists(inBackground: false)
                } else {
                    await viewModel.fetchTopPlaylists(inBackground: true)
                }
            }
        }
    }
}

#Preview {
    HomeView(
        viewModel: HomeViewModel(),
        spotifyController: SpotifyController()
    )
}
