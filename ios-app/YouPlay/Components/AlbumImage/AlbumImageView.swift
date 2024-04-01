//
//  AlbumnImageView.swift
//  YouPlay
//
//  Created by Sebastian on 3/31/24.
//

import SwiftUI

struct AlbumImageView: View {
    let image: SpotifyImage?
    let width: CGFloat
    let height: CGFloat

    var borderRadius: ImageBorderRadius = .medium

    var body: some View {
        if let url = image?.url, let imageUrl = URL(string: url) {
            AsyncImageView(imageUrl: imageUrl, width: width, height: height, borderRadius: borderRadius)
        } else {
            DefaultImageView(width: width, height: height, borderRadius: borderRadius)
        }
    }
}

struct AsyncImageView: View {
    let imageUrl: URL
    let width: CGFloat
    let height: CGFloat
    let borderRadius: ImageBorderRadius

    var body: some View {
        AsyncImage(url: imageUrl) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: height)
                    .cornerRadius(borderRadius.rawValue)
            case .failure:
                DefaultImageView(width: width, height: height, borderRadius: borderRadius)
            @unknown default:
                EmptyView()
            }
        }
    }
}

struct DefaultImageView: View {
    let width: CGFloat
    let height: CGFloat
    let borderRadius: ImageBorderRadius

    var body: some View {
        Image(systemName: "testSpotifyImage")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: height)
            .cornerRadius(borderRadius.rawValue)
    }
}

enum ImageBorderRadius: CGFloat {
    case small = 6.0
    case medium = 8.0
    case large = 16.0
}
