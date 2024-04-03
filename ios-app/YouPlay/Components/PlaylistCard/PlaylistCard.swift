//
//  PlaylistCard.swift
//  YouPlay
//
//  Created by Sebastian on 4/3/24.
//

import SwiftUI

struct PlaylistCardView: View {
    let playlist: Playlist
    var maxHeight = 60.0

    var body: some View {
        HStack {
            AlbumImageView(
                image: SpotifyImage(url: playlist.imageUrl),
                width: maxHeight,
                height: maxHeight,
                borderRadius: .none
            )

            Text(playlist.title)
                .font(.caption)
                .fontWeight(.semibold)
                .lineLimit(1)
                .padding(5)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: maxHeight)
        .background(Color(.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .clipped()
    }
}

#Preview {
    PlaylistCardView(playlist: Playlist.mock)
}
