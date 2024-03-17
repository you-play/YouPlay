//
//  AuthService.swift
//  YouPlay
//
//  Created by Sebastian on 3/15/24.
//

import FirebaseAuth
import Foundation

/// The `AuthService` handles authentication via `Firebase`.
protocol AuthService {
    var userSession: FirebaseAuth.User? { get }

    func login(email: String, password: String) async throws
    func createUser(email: String, password: String) async throws
    func logout()
    func resetPassword(email: String) async throws
}
