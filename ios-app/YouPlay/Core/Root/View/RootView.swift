//
//  ContentView.swift
//  YouPlay
//
//  Created by Sebastian on 3/10/24.
//

import SwiftUI

struct RootView: View {
    @StateObject private var viewModel = RootViewModel()
    @State private var isShowingSongDetail = false

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

                        if let song = viewModel.song,
                           viewModel.currentUser != nil
                        {
                            VStack {
                                Spacer()

                                Button(action: {
                                    isShowingSongDetail.toggle()
                                }) {
                                    HStack {
                                        // song info
                                        HStack(spacing: 12) {
                                            // image
                                            Image(song.imageName)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(maxWidth: 42, maxHeight: 42)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                                .clipped()

                                            VStack(alignment: .leading) {
                                                // song title
                                                Text(song.title)
                                                    .font(.callout)
                                                    .fontWeight(.semibold)
                                                    .lineLimit(1)

                                                // artist name
                                                Text(song.artists.joined(separator: ", "))
                                                    .font(.caption)
                                                    .foregroundStyle(.gray)
                                                    .lineLimit(1)
                                            }
                                        }

                                        Spacer()

                                        // play/pause button
                                        Button(action: {
                                            viewModel.isPaused.toggle()
                                            // TODO: play/pause song
                                            print(viewModel.isPaused ? "Pause song" : "Play song")
                                        }) {
                                            Image(systemName: viewModel.isPaused ? "play.circle.fill" : "pause.circle.fill")
                                                .foregroundColor(.primary)
                                                .font(.system(size: 30))
                                        }
                                        .padding(.trailing, 8)
                                    }
                                    .padding(8)
                                    .background(Color.gray.opacity(0.15))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .padding(.horizontal, 6)
                                }
                                .tint(.white)

                                Spacer()
                                    .frame(height: 60)
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
    }
}

#Preview {
    RootView()
}
