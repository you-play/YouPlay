//
//  HomeLoadingCard.swift
//  YouPlay
//
//  Created by Sebastian on 4/13/24.
//

import SwiftUI

struct SkeletonCardRowView: View {
    let numCards = 4

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(1 ... numCards, id: \.self) { _ in
                    LoadingCardView()
                }
            }
            .padding(.horizontal)
        }
        .frame(maxHeight: SONG_CARD_SIZE + (2 * SONG_CARD_METADATA_SIZE))
    }
}

private struct LoadingCardView: View {
    let size = SONG_CARD_SIZE
    let metadataHeight = SONG_CARD_METADATA_SIZE

    var body: some View {
        VStack(alignment: .leading) {
            // image
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: size, height: size)
                .cornerRadius(8)
                .padding(.bottom, 5)

            // song title
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: size * 0.9, height: 12)

            // artist
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: size * 0.6, height: 10)
        }
        .frame(width: size, height: size + metadataHeight)
    }
}

#Preview {
    SkeletonCardRowView()
}
