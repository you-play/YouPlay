//
//  UserServiceImpl.swift
//  YouPlay
//
//  Created by Sebastian on 3/10/24.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class UserServiceImpl: UserService {
    private init() {}
    static let shared = UserServiceImpl()

    @Published var currentUser: User?

    @MainActor
    func getUserMetadata(uid: String) async throws -> User? {
        do {
            let snapshot = try await FirestoreConstants.UsersCollection.document(uid).getDocument()
            let user = try snapshot.data(as: User.self)
            currentUser = user

            print("DEBUG: retrieved data for user with email \(user.email)")
            return user
        } catch {
            print("DEBUG: unable to find metadata for uid \(uid)", error.localizedDescription)
            return nil
        }
    }

    @MainActor
    func updateUserMetadata(uid: String, user: User) async throws {
        guard let encodedUser = try? Firestore.Encoder().encode(user) else {
            print("DEBUG: unable to encode user with email \(user.email)")
            return
        }

        try await FirestoreConstants.UsersCollection.document(uid).setData(encodedUser)
        print("DEBUG: updated user metadata with email \(user.email)")
    }

    func updateProfileImage(uid: String, imageData: Data) async throws {
        let imageUrl = try await StorageServiceImpl.shared.uploadImage(
            bucket: .ProfileImages,
            fileName: uid,
            imageData: imageData
        )

        guard var user = try await getUserMetadata(uid: uid) else {
            print("DEBUG: no metadata found for user with uid \(uid), unable to update profile image")
            return
        }
        user.profileImageUrl = imageUrl

        try await updateUserMetadata(uid: uid, user: user)
    }

    func addSongToRecents(uid: String, songId: String) async {
        let userRef = FirestoreConstants.UsersCollection.document(uid)

        do {
            var snapshot = try await userRef.getDocument(as: User.self)
            let recentSongIds = snapshot.recentSongIds ?? []
            var updatedRecentSongIds: [String] = [songId] // most recent at the top

            for recentSongId in recentSongIds {
                if updatedRecentSongIds.count == MAX_ALLOWED_RECENT_SONGS {
                    break
                }

                if recentSongId != songId {
                    updatedRecentSongIds.append(recentSongId)
                }
            }

            snapshot.recentSongIds = updatedRecentSongIds
            let encodedData = try Firestore.Encoder().encode(snapshot)
            try await userRef.setData(encodedData)
            print("DEBUG: update recent songs for uid \(uid)")
        } catch {
            print("DEBUG: unable to add recent song with id \(songId) for user with uid \(uid)", error.localizedDescription)
        }
    }

    func getRecentSongs(uid: String) async -> [Song] {
        let userRef = FirestoreConstants.UsersCollection.document(uid)

        var recentSongIds: [String] = []
        do {
            let snapshot = try await userRef.getDocument(as: User.self)
            recentSongIds = snapshot.recentSongIds ?? []
            print("DEBUG: retrieved \(recentSongIds.count) recent songs for user with uid \(uid)")
        } catch {
            print("DEBUG: unable to retrieve recent song ids for user with uid \(uid)", error.localizedDescription)
        }

        var recentSongs: [Song] = []
        for songId in recentSongIds {
            if let song = await SpotifyServiceImpl.shared.getSongDetails(id: songId) {
                recentSongs.append(song)
            }
        }

        return recentSongs
    }

    @MainActor
    func isRecentSong(uid: String, songId: String) async -> Bool {
        let userRef = FirestoreConstants.UsersCollection.document(uid)

        do {
            let snapshot = try await userRef.getDocument(as: User.self)

            if snapshot.recentSongIds?.firstIndex(of: songId) != nil {
                return true
            }
        } catch {
            print("DEBUG: unable to retrieve recent song ids for user with uid \(uid)", error.localizedDescription)
        }

        return false
    }

    func clearRecentSongs(uid: String) async {
        let userRef = FirestoreConstants.UsersCollection.document(uid)

        do {
            var snapshot = try await userRef.getDocument(as: User.self)

            snapshot.recentSongIds?.removeAll()
            let encodedData = try Firestore.Encoder().encode(snapshot)
            try await userRef.setData(encodedData)
            print("DEBUG: clear all recents songs for uid \(uid)")
        } catch {
            print("DEBUG: unable clear all recents songs for uid \(uid)", error.localizedDescription)
        }
    }

    /// Sets up a "demo" account with some default playlists.
    @MainActor
    func setupDemoAccount(uid: String) async {
        guard let fileURL = Bundle.main.url(forResource: "playlists-with-song-ids", withExtension: "json") else {
            print("DEBUG: JSON file not found to set up demo account")
            return
        }

        do {
            let data = try Data(contentsOf: fileURL)
            let playlists = try JSONDecoder().decode([PlaylistData].self, from: data)

            for playlist in playlists {
                guard let playlistId = await PlaylistServiceImpl.shared.createPlaylist(
                    uid: uid,
                    name: playlist.title,
                    imageUrl: playlist.imageUrl
                ) else {
                    print("DEBUG: unable to set up playlist \(playlist.title) for demo account for uid \(uid)")
                    continue
                }

                await PlaylistServiceImpl.shared.addManySongsToPlaylist(
                    uid: uid,
                    playlistId: playlistId,
                    songIds: playlist.songIds
                )
            }
        } catch {
            print("DEBUG: unable to set up demo account", error)
        }
    }
}

private struct PlaylistData: Decodable {
    let title: String
    let songIds: [String]
    let imageUrl: String
}
