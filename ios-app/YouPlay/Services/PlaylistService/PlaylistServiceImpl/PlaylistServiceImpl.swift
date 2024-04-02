//
//  PlaylistServiceImpl.swift
//  YouPlay
//
//  Created by Sebastian on 4/1/24.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class PlaylistServiceImpl: PlaylistService {
    static let shared = PlaylistServiceImpl()

    private init() {}

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
    func getPlaylists(uid: String) async -> [Playlist] {
        let playlistsRef = FirestoreConstants.PlaylistsCollection(uid: uid)

        var playlists: [Playlist] = []
        do {
            let snapshot = try await playlistsRef
                .order(by: "title", descending: false)
                .getDocuments()

            playlists = snapshot.documents
                .compactMap { document in
                    try? document.data(as: Playlist.self)
                }

        } catch {
            print("DEBUG: unable to get playlists for user \(uid)", error.localizedDescription)
        }

        return playlists
    }
}
