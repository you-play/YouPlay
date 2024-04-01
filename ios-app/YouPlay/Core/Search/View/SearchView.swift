//
//  SearchView.swift
//  YouPlay
//
//  Created by Sebastian on 3/13/24.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel = SearchViewModel()

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

                    TextField("Search...", text: $viewModel.searchQuery)
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

            List(viewModel.searchResults?.tracks?.items ?? [], id: \.id) { song in
                Button {
                    // TODO: play the song
                    print("Now playing: \(song.name)")
                } label: {
                    HorizontalSongView(song: song)
                }
            }
            .overlay {
                if viewModel.searchQuery.isEmpty {
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
    SearchView(viewModel: SearchViewModel())
}
