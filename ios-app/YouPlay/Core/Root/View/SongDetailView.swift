//
//  SongDetailView.swift
//  YouPlay
//
//  Created by Joshua lopes on 3/22/24.
//

import SwiftUI

struct SongDetailView: View {
    @StateObject var viewModel = RootViewModel(spotifyController: SpotifyController())

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                AlbumImageView(
                    image: viewModel.song?.album.images.first,
                    width: 400.0,
                    height: 400.0,
                    borderRadius: .large
                )
                .padding(.bottom, 20)

                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(viewModel.song?.name ?? "Song title unavailable")
                            .font(.title2)
                            .fontWeight(.bold)
                            .lineLimit(1)

                        Text(viewModel.song?.artists
                            .compactMap { artist in artist.name }
                            .joined(separator: ", ") ?? "Artist(s) unavailable"
                        )
                        .foregroundStyle(.gray)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    }

                    Spacer()

                    // Like button
                    Button(action: {
                        viewModel.isLiked.toggle()
                        Task {
                            if let currentUser = viewModel.currentUser,
                               let song = viewModel.song
                            {
                                Task {
                                    await viewModel.addLikedSongToPlaylis(user: currentUser, song: song)
                                }
                            }
                        }

                        print(viewModel.isLiked ? "Liked song" : "Unliked song")
                    }) {
                        Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 25, height: 25)
                            .foregroundColor(viewModel.isLiked ? .green : .white)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)

                // playback controlls
                HStack(spacing: 50) {
                    // prev
                    Button(action: {
                        // TODO: go to prev song
                        print("Previous song")
                    }) {
                        Image(systemName: "backward.end.fill")
                            .foregroundColor(.primary)
                            .font(.system(size: 30))
                    }

                    // play/pause
                    Button(action: {
                        viewModel.spotifyController.pauseOrPlay()
                    }) {
                        Image(systemName: viewModel.isPaused ? "play.circle.fill" : "pause.circle.fill")
                            .foregroundColor(.primary)
                            .font(.system(size: 60))
                    }

                    // next song
                    Button(action: {
                        // TODO: skip song
                        print("Next song")
                    }) {
                        Image(systemName: "forward.end.fill")
                            .foregroundColor(.primary)
                            .font(.system(size: 30))
                    }
                }
                .font(.title)
                .padding(.top, 20)
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    NavigationLink {
                        if viewModel.playlists.isEmpty {
                            ContentUnavailableView(
                                "Don't drop the mic!",
                                systemImage: "music.mic.circle.fill",
                                description: Text("Head over to Playlists to start adding songs")
                            )
                        } else {
                            ScrollView(.vertical) {
                                LazyVStack {
                                    ForEach(viewModel.playlists) { playlist in
                                        Button {
                                            Task {
                                                if let currentUser = viewModel.currentUser,
                                                   let song = viewModel.song
                                                {
                                                    Task {
                                                        await viewModel.addSongToPlaylist(
                                                            user: currentUser,
                                                            playlist: playlist,
                                                            song: song
                                                        )

                                                        dismiss()
                                                    }
                                                } else {
                                                    print("DEBUG: Unable to add to song to playlist without both a currentUser and song")
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
                    } label: {
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
        }
        .tint(.green)
    }
}

#Preview {
    NavigationStack {
        SongDetailView(viewModel: RootViewModel(spotifyController: SpotifyController()))
    }
}
