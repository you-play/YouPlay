//
//  HorizontalSongView.swift
//  YouPlay
//
//  Created by Joshua lopes on 3/31/24.
//

import SwiftUI

struct HorizontalSongView: View {
    let song: SongResponse

    private let imageSizePx = 45.0
    private let imageBorderRadius = 5.0

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if let displayImage = song.album.images.first, let imageUrl = URL(string: displayImage.url) {
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: imageSizePx, height: imageSizePx)
                            .cornerRadius(imageBorderRadius)
                    case .failure:
                        Image(systemName: "testSpotifyImage")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: imageSizePx, height: imageSizePx)
                            .cornerRadius(imageBorderRadius)
                    @unknown default:
                        // Handle future cases
                        EmptyView()
                    }
                }
            } else {
                // If the imageUrl is not valid, display a default placeholder
                Image(systemName: "testSpotifyImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imageSizePx, height: imageSizePx)
                    .cornerRadius(imageBorderRadius)
            }

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
    HorizontalSongView(song: SongResponse.mock)
}
