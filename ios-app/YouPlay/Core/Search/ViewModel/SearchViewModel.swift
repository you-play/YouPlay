//
//  SearchViewModel.swift
//  YouPlay
//
//  Created by Sebastian on 3/13/24.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var searchQuery = ""
    @Published var searchResults: SpotifySearchResponse? = nil

    init() {}

    @MainActor
    func searchSongs(query: String) async {
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
