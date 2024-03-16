//
//  ProfileView.swift
//  YouPlay
//
//  Created by Sebastian on 3/10/24.
//

import PhotosUI
import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    var user: User

    var body: some View {
        VStack {
            VStack {
                PhotosPicker(selection: $viewModel.selectedItem) {
                    if let profileImage = viewModel.profileImage {
                        profileImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: ProfileImageSize.xxLarge.dimension, height: ProfileImageSize.xxLarge.dimension)
                            .clipShape(Circle())
                    } else {
                        CircularProfileImageView(user: user, size: .xxLarge)
                    }
                }

                Text(user.username)
                    .font(.title2)
                    .fontWeight(.semibold)
            }

            List {
                Section {
                    Button("Log Out") {
                        print("DEBUG: logging out")
                        AuthServiceImpl.shared.logout()
                    }
                    .tint(.red)
                }
            }
        }
    }
}

#Preview {
    ProfileView(user: User.mock)
}
