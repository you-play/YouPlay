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

    func getUserMetadata(uid: String) async throws
    func updateUserMetadata(uid: String, user: User) async throws
}
