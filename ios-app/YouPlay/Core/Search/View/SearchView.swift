//
//  SearchView.swift
//  YouPlay
//
//  Created by Sebastian on 3/13/24.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel = SearchViewModel()
    @ObservedObject var spotifyController: SpotifyController

    var body: some View {
        VStack {
            ZStack {
                // Background and search icon
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(.systemGray6))
                    .frame(height: 48)

                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                        .padding(.leading, 5)
                        .imageScale(.large)

                    TextField("What to do you want to listen to?", text: $viewModel.searchQuery)
                        .padding(.vertical, 10)
                        .padding(.leading, 10)
                        .foregroundColor(.white)

                    Spacer()

                    // clear button
                    if !viewModel.searchQuery.isEmpty {
                        Button {
                            viewModel.clear()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white)
                                .padding(.trailing, 5)
                                .imageScale(.medium)
                        }
                    }
                }
                .padding(.horizontal, 10)
            }
            .padding()
            .onChange(of: viewModel.searchQuery) { _, newValue in
                Task {
                    await viewModel.searchSongs(query: newValue)
                }
            }

            List {
                ForEach(viewModel.searchQuery.isEmpty
                    ? viewModel.recentSongs
                    : viewModel.searchResults?.tracks?.items ?? [])
                { song in
                    Button {
                        spotifyController.play(uri: song.uri)

                        Task {
                            let isRecent = await viewModel.isRecent(songId: song.id)

                            if !isRecent {
                                await viewModel.addSongToRecents(songId: song.id)
                                await viewModel.fetchRecentSongs()
                            }
                        }
                    } label: {
                        HorizontalSongView(song: song)
                    }
                }

                if viewModel.recentSongs.count > 6 {
                    Button("Clear recent searches") {
                        Task {
                            await viewModel.clearAllRecents()
                            await viewModel.fetchRecentSongs()
                        }
                    }
                    .padding()
                    .foregroundStyle(Color.green)
                    .padding(.bottom, 64)
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.searchQuery.isEmpty && viewModel.recentSongs.isEmpty {
                    ContentUnavailableView(
                        "Don't drop the mic!",
                        systemImage: "music.mic.circle.fill",
                        description: Text("Start typing to find latest and greatest")
                    )
                } else if viewModel.searchResults?.tracks?.total == 0 {
                    ContentUnavailableView.search
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationBarTitle(Text("Search"), displayMode: .inline)
    }
}

#Preview {
    SearchView(viewModel: SearchViewModel(), spotifyController: SpotifyController())
}
