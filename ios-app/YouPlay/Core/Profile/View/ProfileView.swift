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
    @ObservedObject var spotifyController: SpotifyController

    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            VStack {
                VStack {
                    PhotosPicker(selection: $viewModel.selectedImage) {
                        if let profileImage = viewModel.profileImage {
                            profileImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: ProfileImageSize.xxLarge.dimension, height: ProfileImageSize.xxLarge.dimension)
                                .clipShape(Circle())
                        } else {
                            CircularProfileImageView(user: viewModel.currentUser, size: .xxLarge)
                        }
                    }

                    Text(viewModel.currentUser?.username ?? "Username unavailable")
                        .font(.title2)
                        .fontWeight(.semibold)
                }

                List {
                    Section {
                        NavigationLink {
                            DemoAccountView(viewModel: viewModel)
                        } label: {
                            Text("Setup Demo Account")
                                .tint(.green)
                        }
                    }

                    Section {
                        Button("Log Out") {
                            print("DEBUG: logging out")
                            AuthServiceImpl.shared.logout()
                            spotifyController.disconnect()
                            dismiss()
                        }
                        .tint(.red)
                    }
                }
            }
            .toolbar {
                if viewModel.selectedImage != nil {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("\(viewModel.isSaving ? "Saving..." : "Save")") {
                            viewModel.saveSelectedImage()
                        }
                        .disabled(viewModel.isSaving)
                    }
                }
            }

            if viewModel.isSaving || viewModel.isLoading {
                Color.black.opacity(0.5).ignoresSafeArea()
                ProgressView()
            }
        }
    }
}

#Preview {
    ProfileView(spotifyController: SpotifyController())
}
