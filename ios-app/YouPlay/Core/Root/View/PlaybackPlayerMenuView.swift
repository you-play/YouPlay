//
//  SongDetailMenu.swift
//  YouPlay
//
//  Created by Sebastian on 4/8/24.
//

import SwiftUI

struct PlaybackPlayerMenuView: View {
    @ObservedObject var viewModel: RootViewModel

    @Environment(\.dismiss) private var dismiss
    private var playlists: [Playlist] {
        viewModel.playlists
    }

    var body: some View {
        Menu {
            NavigationLink(destination: playlistListView) {
                Text("Add to playlist")
            }
        } label: {
            Image(systemName: "gearshape.fill")
        }
        .tint(.white)
        .onTapGesture {
            Task {
                await viewModel.fetchPlaylists()
            }
        }
    }

    private var playlistListView: some View {
        VStack {
            if playlists.isEmpty {
                ContentUnavailableView(
                    "Don't drop the mic!",
                    systemImage: "music.mic.circle.fill",
                    description: Text("Head over to Playlists to start adding songs")
                )
            } else {
                ScrollView(.vertical) {
                    LazyVStack {
                        ForEach(playlists) { playlist in
                            Button {
                                Task {
                                    if let currentUser = viewModel.currentUser, let song = viewModel.song {
                                        await viewModel.addSongToPlaylist(user: currentUser, playlist: playlist, song: song)
                                        dismiss()
                                    } else {
                                        print("DEBUG: Unable to add song to playlist without both a currentUser and song")
                                    }
                                }
                            } label: {
                                PlaylistCardView(playlist: playlist, maxHeight: 80)
                                    .padding(.bottom, 8)
                            }
                            .tint(.white)
                        }
                        Spacer()
                    }
                    .padding()
                    .navigationTitle("Add to playlist")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
}

#Preview {
    PlaybackPlayerMenuView(viewModel: RootViewModel(spotifyController: SpotifyController()))
}
