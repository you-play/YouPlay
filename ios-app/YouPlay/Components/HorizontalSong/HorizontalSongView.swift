//
//  HorizontalSongView.swift
//  YouPlay
//
//  Created by Joshua lopes on 3/31/24.
//

import SwiftUI

struct HorizontalSongView: View {
    let song: Song

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AlbumImageView(
                image: song.album.images.first,
                width: 45.0,
                height: 45.0,
                borderRadius: .small
            )

            VStack(alignment: .leading) {
                Text(song.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                Text(song.artists.compactMap { artist in
                    artist.name
                }.joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            Spacer()
        }
    }
}

#Preview {
    HorizontalSongView(song: Song.mock)
}
