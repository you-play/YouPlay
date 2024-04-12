//
//  UserService.swift
//  YouPlay
//
//  Created by Sebastian on 3/10/24.
//

import Foundation

/// The `UserService` manages all internal user metadata.
protocol UserService {
    var currentUser: User? { get set }

    func getUserMetadata(uid: String) async throws -> User?
    func updateUserMetadata(uid: String, user: User) async throws
    func updateProfileImage(uid: String, imageData: Data) async throws
    func addSongToRecents(uid: String, songId: String) async
    func getRecentSongs(uid: String) async -> [Song]
    func isRecentSong(uid: String, songId: String) async -> Bool
    func clearRecentSongs(uid: String) async
    func setupDemoAccount(uid: String) async
}
