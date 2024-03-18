//
//  CircularProfileImageView.swift
//  YouPlay
//
//  Created by Sebastian on 3/16/24.
//

import SwiftUI

/// A quick and easy circular image for a `User` with built-in placeholder and loading states.
///
/// You can configure the `size` of the image.
struct CircularProfileImageView: View {
    var user: User?
    var size: ProfileImageSize = .xSmall

    var body: some View {
        if let imageUrl = user?.profileImageUrl {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()

            } placeholder: {
                ProgressView()
            }
            .frame(width: size.dimension, height: size.dimension)
            .clipShape(Circle())
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFill()
                .frame(width: size.dimension, height: size.dimension)
                .foregroundStyle(Color(.systemGray4))
        }
    }
}

/// Represents the different sizes available for a `CircularProfileImageView`
enum ProfileImageSize {
    case xxSmall
    case xSmall
    case small
    case medium
    case large
    case xLarge
    case xxLarge

    var dimension: Double {
        switch self {
        case .xxSmall: 28
        case .xSmall: 32
        case .small: 40
        case .medium: 56
        case .large: 64
        case .xLarge: 80
        case .xxLarge: 130
        }
    }
}

#Preview {
    CircularProfileImageView(user: User.mock, size: .xxLarge)
}
