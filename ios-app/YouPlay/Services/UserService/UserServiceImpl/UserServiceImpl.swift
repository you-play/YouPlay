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
    func getUserMetadata(uid: String) async throws {
        let snapshot = try await FirestoreConstants.UsersCollection.document(uid).getDocument()
        let user = try snapshot.data(as: User.self)

        self.currentUser = user
        print("DEBUG: retrieved data for user with email \(user.email)")
    }

    @MainActor
    func updateUserMetadata(uid: String, user: User) async throws {
        guard let encodedUser = try? Firestore.Encoder().encode(user) else {
            print("DEBUG: unable to encode user with email \(user.email)")
            return
        }

        try await FirestoreConstants.UsersCollection.document(uid).setData(encodedUser)
        print("DEBUG: saved user metadata with email \(user.email)")
    }
}
