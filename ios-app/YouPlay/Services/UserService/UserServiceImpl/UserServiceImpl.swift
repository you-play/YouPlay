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
            print("DEBUG: unable to find metadata for ui \(uid)", error.localizedDescription)
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
}
