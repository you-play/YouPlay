//
//  PlaylistCard.swift
//  YouPlay
//
//  Created by Sebastian on 4/3/24.
//

import SwiftUI

struct PlaylistCardView: View {
    let playlist: Playlist

    let maxHeight = 100.0

    var body: some View {
        HStack {
            AlbumImageView(
                image: SpotifyImage(url: playlist.imageUrl),
                width: maxHeight,
                height: maxHeight,
                borderRadius: .none
            )

            Text(playlist.title)
                .font(.title3)
                .fontWeight(.semibold)
                .lineLimit(1)
                .padding(8)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: maxHeight)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .clipped()
    }
}

#Preview {
    PlaylistCardView(playlist: Playlist.mock)
}
