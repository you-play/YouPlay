//
//  SongCrumbBar.swift
//  YouPlay
//
//  Created by Sebastian on 4/8/24.
//

import SwiftUI

struct CrumbBarPlayerView: View {
    @ObservedObject var viewModel: RootViewModel
    @Binding var showPlaybackPlayer: Bool
    @Binding var keyboardHeight: CGFloat

    var body: some View {
        if let song = viewModel.song,
           viewModel.currentUser != nil,
           keyboardHeight == 0.0 // hide when keyboard is open
        {
            VStack {
                Spacer()

                Button {
                    showPlaybackPlayer.toggle()
                } label: {
                    HStack {
                        // song info
                        HStack(spacing: 12) {
                            AlbumImageView(
                                image: song.album.images.first,
                                width: 42.0,
                                height: 42.0,
                                borderRadius: .small
                            )

                            VStack(alignment: .leading) {
                                Text(song.name)
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .lineLimit(1)

                                Text(song.artists
                                    .compactMap { artist in artist.name }
                                    .joined(separator: ", ")
                                )
                                .font(.caption)
                                .foregroundStyle(.gray)
                                .lineLimit(1)
                            }
                        }

                        Spacer()

                        // play/pause button
                        Button {
                            viewModel.spotifyController.pauseOrPlay()
                        } label: {
                            Image(systemName: viewModel.isPaused ? "play.circle.fill" : "pause.circle.fill")
                                .foregroundColor(.primary)
                                .font(.system(size: 30))
                        }
                        .padding(.trailing, 8)
                    }
                    .padding(8)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal, 6)
                }
                .tint(.white)

                // the following spacers account for the TabBar
                Spacer()
                    .frame(width: UIScreen.main.bounds.width, height: 10)
                    .background(Color.black.opacity(0.8))

                Spacer()
                    .frame(width: UIScreen.main.bounds.width, height: 45)
            }
        }
    }
}

#Preview {
    CrumbBarPlayerView(viewModel: RootViewModel(spotifyController: SpotifyController()),
                 showPlaybackPlayer: .constant(false),
                 keyboardHeight: .constant(0.0))
}
