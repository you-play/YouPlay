//
//  SearchView.swift
//  YouPlay
//
//  Created by Sebastian on 3/13/24.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel = SearchViewModel()
    @State private var searchQuery = ""
    @State private var searchResults: SpotifySearchResponse? = nil

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
                    TextField("Search...", text: self.$searchQuery)
                        .padding(.vertical, 10)
                        .padding(.leading, 10)
                        .foregroundColor(.white)

                    Spacer()
                }
                .padding(.horizontal, 10)
            }
            .padding()
            .onChange(of: self.searchQuery) { newValue in
                Task {
                    await self.searchSongs(query: newValue)
                }
            }

            List(self.searchResults?.tracks?.items ?? [], id: \.id) { item in
                HStack {
                    // Your song row goes here
                    HorizontalSongView(
                        songTitle: item.name,
                        songArtists: item.artists.map { $0.name },
                        imageUrl: item.album.images.first?.url ?? ""
                    )
                }
            }
        }
        .navigationBarTitle(Text("Search"), displayMode: .inline)
    }

    private func searchSongs(query: String) async {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            self.searchResults = nil
            return
        }
        if let results = await SpotifyServiceImpl.shared.search(text: query) {
            DispatchQueue.main.async { [self] in
                self.searchResults = results
            }
        } else {
            DispatchQueue.main.async {
                self.searchResults = nil
            }
        }
    }
}

#Preview {
    SearchView(viewModel: SearchViewModel())
}
