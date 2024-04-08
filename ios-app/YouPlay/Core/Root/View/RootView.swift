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
    @State private var isShowingSongDetail = false
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

                        // Song player crumbar
                        if let song = viewModel.song,
                           viewModel.currentUser != nil,
                           keyboardHeight == 0.0 // hide when keyboard is open
                        {
                            VStack {
                                Spacer()

                                Button(action: {
                                    isShowingSongDetail.toggle()
                                }) {
                                    HStack {
                                        // song info
                                        HStack(spacing: 12) {
                                            AlbumImageView(
                                                image: song.album.images.first,
                                                width: 42.0,
                                                height: 42.0,
                                                borderRadius: .small
                                            )

                                            VStack(alignment: .leading) {
                                                Text(song.name)
                                                    .font(.callout)
                                                    .fontWeight(.semibold)
                                                    .lineLimit(1)

                                                Text(song.artists
                                                    .compactMap { artist in artist.name }
                                                    .joined(separator: ", ")
                                                )
                                                .font(.caption)
                                                .foregroundStyle(.gray)
                                                .lineLimit(1)
                                            }
                                        }

                                        Spacer()

                                        // play/pause button
                                        Button {
                                            viewModel.spotifyController.pauseOrPlay()
                                        } label: {
                                            Image(systemName: viewModel.isPaused ? "play.circle.fill" : "pause.circle.fill")
                                                .foregroundColor(.primary)
                                                .font(.system(size: 30))
                                        }
                                        .padding(.trailing, 8)
                                    }
                                    .padding(8)
                                    .background(Color(.systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .padding(.horizontal, 6)
                                }
                                .tint(.white)

                                // the following spacers account for the TabBar
                                Spacer()
                                    .frame(width: UIScreen.main.bounds.width, height: 10)
                                    .background(Color.black.opacity(0.8))

                                Spacer()
                                    .frame(width: UIScreen.main.bounds.width, height: 45)
                            }
                        }
                    }
                }
                .tint(.green)
            }
        }
        .sheet(isPresented: $isShowingSongDetail) {
            NavigationStack {
                SongDetailView(viewModel: viewModel)
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
