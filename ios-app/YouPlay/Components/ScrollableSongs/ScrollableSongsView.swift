//
//  ScrollableSongsView.swift
//  YouPlay
//
//  Created by Joshua lopes on 3/22/24.
//

import SwiftUI

struct ScrollableSongsView: View {
    let title: String
    let songs: [Song]
    @ObservedObject var spotifyController: SpotifyController

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.leading, 16)
                .padding(.top, 5)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(songs) { song in
                        Button {
                            spotifyController.play(uri: song.uri)
                        } label: {
                            SongRowView(song: song)
                        }
                        .tint(.white)
                    }
                }
                .padding(.horizontal)
            }
        }
        .frame(maxHeight: 215)
    }
}

struct SongRowView: View {
    let song: Song

    let size = 120.0
    let metadataHeight = 50.0

    var body: some View {
        VStack(alignment: .leading) {
            AlbumImageView(
                image: song.album.images.first,
                width: size,
                height: size,
                borderRadius: .small
            )
            .padding(.bottom, 5)

            Text(song.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(1)

            Text(song.artists
                .compactMap { artist in artist.name }
                .joined(separator: ", ")
            )
            .font(.caption2)
            .foregroundStyle(.gray)
            .lineLimit(1)
        }
        .frame(width: size, height: size + metadataHeight)
    }
}

#Preview {
    ScrollableSongsView(
        title: "Recommended",
        songs: Song.mocks,
        spotifyController: SpotifyController()
    )
}
