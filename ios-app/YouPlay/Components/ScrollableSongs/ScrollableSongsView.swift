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

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .padding(.leading, 16)
                .padding(.top, 5)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20) {
                    ForEach(songs) { song in
                        // TODO: we have to convert each of these into a Link and open the song they clicked on
                        VStack(alignment: .leading) {
                            Image(song.imageName) // TODO: update to open image from URL
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 120)
                                .clipped()
                                .cornerRadius(6)
                                .padding(.bottom, 5)

                            Text(song.title)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .lineLimit(1)

                            Text(song.artists.joined(separator: ", "))
                                .font(.caption2)
                                .foregroundStyle(.gray)
                                .lineLimit(1)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .frame(maxHeight: 200)
    }
}

#Preview {
    ScrollableSongsView(
        title: "Recommended",
        songs: [Song.mock, Song.mock, Song.mock, Song.mock]
    )
}
