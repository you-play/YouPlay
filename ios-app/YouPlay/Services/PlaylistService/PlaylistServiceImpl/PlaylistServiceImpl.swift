//
//  PlaylistServiceImpl.swift
//  YouPlay
//
//  Created by Sebastian on 4/1/24.
//

import Combine
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class PlaylistServiceImpl: PlaylistService {
    static let shared = PlaylistServiceImpl()

    @Published var playlists: [Playlist] = []

    private var currentUser: User?
    private var cancellables = Set<AnyCancellable>()

    private init() {
        setupSubscribers()
    }

    /// Sets up the default playlists for a given user's id.
    func setupDefaultPlaylists(uid: String) async {
        let playlistsRef = FirestoreConstants.PlaylistsCollection(uid: uid)

        do {
            for playlist in DEFAULT_PLAYLISTS {
                let encodedDefaultPlaylists = try Firestore.Encoder().encode(playlist)

                try await playlistsRef.document().setData(encodedDefaultPlaylists)
                print("DEBUG: set up default playlist \(playlist.title) for user \(uid)")
            }
        } catch {
            print("DEBUG: unable to setup default playlists for user \(uid)", error.localizedDescription)
        }
    }

    /// Retrieves the playlists in ascending alphabetical order for a given user.
    @MainActor
    func getPlaylists(uid: String) async -> [Playlist] {
        let playlistsRef = FirestoreConstants.PlaylistsCollection(uid: uid)

        var playlists: [Playlist] = []
        do {
            let snapshot = try await playlistsRef.getDocuments()
            playlists = snapshot.documents
                .compactMap { document in
                    try? document.data(as: Playlist.self)
                }
                .sorted(by: { p1, p2 in
                    p1.title < p2.title
                })
        } catch {
            print("DEBUG: unable to get playlists for user \(uid)", error.localizedDescription)
        }

        self.playlists = playlists
        return playlists
    }

    private func setupSubscribers() {
        UserServiceImpl.shared.$currentUser.sink { [weak self] currentUser in
            self?.currentUser = currentUser
        }
        .store(in: &cancellables)
    }
}
