//
//  ContentView.swift
//  YouPlay
//
//  Created by Sebastian on 3/10/24.
//

import Combine
import SwiftUI

struct RootView: View {
    @StateObject private var viewModel = RootViewModel(spotifyController: SpotifyController())
    @State private var showPlaybackPlayer = false
    @State private var keyboardHeight: CGFloat = 0.0

    var body: some View {
        Group {
            if viewModel.currentUser == nil {
                AuthView()
            } else {
                NavigationStack {
                    ZStack {
                        TabBarView(spotifyController: viewModel.spotifyController)
                            .toolbar { // Global toolbar
                                ToolbarItem(placement: .topBarLeading) {
                                    if let user = viewModel.currentUser {
                                        NavigationLink(
                                            destination: ProfileView(spotifyController: viewModel.spotifyController),
                                            label: {
                                                CircularProfileImageView(user: user, size: .small)
                                            }
                                        )
                                    }
                                }
                            }

                        CrumbBarPlayerView(
                            viewModel: viewModel,
                            showPlaybackPlayer: $showPlaybackPlayer,
                            keyboardHeight: $keyboardHeight
                        )
                    }
                }
                .tint(.green)
            }
        }
        .sheet(isPresented: $showPlaybackPlayer) {
            NavigationStack {
                PlaybackPlayerView(viewModel: viewModel)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            PlaybackPlayerMenuView(viewModel: viewModel)
                        }
                    }
            }
            .tint(.green)
        }
        .onReceive(Publishers.keyboardHeight) { keyboardHeight in
            self.keyboardHeight = keyboardHeight
        }
        .onOpenURL { url in
            viewModel.spotifyController.setAccessToken(from: url)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didFinishLaunchingNotification), perform: { _ in
            viewModel.spotifyController.connect()
        })
    }
}

#Preview {
    RootView()
}
