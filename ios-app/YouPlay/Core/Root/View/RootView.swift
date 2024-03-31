//
//  ContentView.swift
//  YouPlay
//
//  Created by Sebastian on 3/10/24.
//

import Combine
import SwiftUI

struct RootView: View {
    @StateObject private var viewModel = RootViewModel()
    @State private var isShowingSongDetail = false
    @State private var keyboardHeight: CGFloat = 0.0
    private let bgOpacity = 0.90

    var body: some View {
        Group {
            if viewModel.currentUser == nil {
                AuthView()
            } else {
                NavigationStack {
                    ZStack {
                        TabBarView()
                            .toolbar { // Global toolbar
                                ToolbarItem(placement: .topBarLeading) {
                                    if let user = viewModel.currentUser {
                                        NavigationLink(
                                            destination: ProfileView(),
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
                                                height: 42.0
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
                                            viewModel.isPaused.toggle()
                                            // TODO: play/pause song
                                            print(viewModel.isPaused ? "Pause song" : "Play song")
                                        } label: {
                                            Image(systemName: viewModel.isPaused ? "play.circle.fill" : "pause.circle.fill")
                                                .foregroundColor(.primary)
                                                .font(.system(size: 30))
                                        }
                                        .padding(.trailing, 8)
                                    }
                                    .padding(8)
                                    .background(Color.black.opacity(bgOpacity))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .padding(.horizontal, 6)
                                }
                                .tint(.white)

                                Spacer()
                                    .frame(width: UIScreen.main.bounds.width, height: 5)
                                    .background(Color.black.opacity(bgOpacity))

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
            SongDetailView(viewModel: viewModel)
        }
        .onReceive(Publishers.keyboardHeight) { keyboardHeight in
            self.keyboardHeight = keyboardHeight
        }
    }
}

#Preview {
    RootView()
}
