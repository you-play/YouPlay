//
//  HorizontalSongView.swift
//  YouPlay
//
//  Created by Joshua lopes on 3/31/24.
//

import SwiftUI

struct HorizontalSongView: View {
    let songTitle: String
    let songArtists: [String]
    let imageUrl: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        // While the image is loading, you can display a placeholder
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .cornerRadius(8)
                    case .failure:
                        Image(systemName: "testSpotifyImage")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .cornerRadius(8)
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
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(songTitle)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(songArtists.joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer() // Pushes everything to the left
        }
        .padding(.all, 10)
    }
}

#Preview {
    HorizontalSongView(songTitle: Song.mock.title, songArtists: Song.mock.artists, imageUrl: "")
}
