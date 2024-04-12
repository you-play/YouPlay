//
//  SearchViewModel.swift
//  YouPlay
//
//  Created by Sebastian on 3/13/24.
//

import Combine
import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var searchQuery = ""
    @Published var searchResults: SpotifySearchResponse? = nil
    @Published var recentSongs: [Song] = []
    @Published var isLoading = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        setupSubscribers()
        Task {
            isLoading = true
            await fetchRecentSongs()
            isLoading = false
        }
    }

    func searchSongs(query: String) async {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            searchResults = nil
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

    func clear() {
        searchQuery = ""
        searchResults = nil
    }

    func addSongToRecents(songId: String) async {
        guard let uid = currentUser?.uid else {
            print("DEBUG: unable to clear all recent songs without a uid")
            return
        }

        await UserServiceImpl.shared.addSongToRecents(uid: uid, songId: songId)
    }

    func isRecent(songId: String) async -> Bool {
        guard let uid = currentUser?.uid else {
            print("DEBUG: unable to check if it's a recent song without a uid")
            return false
        }

        return await UserServiceImpl.shared.isRecentSong(uid: uid, songId: songId)
    }

    func fetchRecentSongs() async {
        guard let uid = currentUser?.uid else {
            print("DEBUG: unable to clear all recent songs without a uid")
            return
        }

        recentSongs = await UserServiceImpl.shared.getRecentSongs(uid: uid)
    }

    func clearAllRecents() async {
        guard let uid = currentUser?.uid else {
            print("DEBUG: unable to clear all recent songs without a uid")
            return
        }

        await UserServiceImpl.shared.clearRecentSongs(uid: uid)
    }

    private func setupSubscribers() {
        UserServiceImpl.shared.$currentUser.sink { [weak self] currentUser in
            self?.currentUser = currentUser
        }
        .store(in: &cancellables)
    }
}
