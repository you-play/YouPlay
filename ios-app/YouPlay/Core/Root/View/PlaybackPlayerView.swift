//
//  SongDetailView.swift
//  YouPlay
//
//  Created by Joshua lopes on 3/22/24.
//

import SwiftUI

struct PlaybackPlayerView: View {
    @StateObject var viewModel = RootViewModel(spotifyController: SpotifyController())

    @Environment(\.dismiss) var dismiss

    var playlist: Playlist
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
                    Button {
                        if let song = viewModel.song {
                            Task {
                                await viewModel.toggleLike(song: song)
                            }
                        }

                    } label: {
                        Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 25, height: 25)
                            .foregroundColor(viewModel.isLiked ? .white : .white)
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
                        viewModel.spotifyController.previousTrack()
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
                        viewModel.spotifyController.nextTrackCustom()
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
        .onAppear {
            Task {
                if let songId = viewModel.song?.id {
                    viewModel.isLiked = await viewModel.isLikedSong(songId: songId)

                    await viewModel.loadPlaylists(playlistId: playlist.id)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PlaybackPlayerView(viewModel: RootViewModel(spotifyController: SpotifyController()))
    }
}
