//
//  AuthViewModel.swift
//  YouPlay
//
//  Created by Sebastian on 3/16/24.
//

import Combine
import Foundation
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""

    func login() async throws {
        print("DEBUG: attemping to login user with email \(email)")
        try await AuthServiceImpl.shared.login(email: email, password: password)
    }

    func signUp() async throws {
        print("DEBUG: attemping to create user with email \(email)")
        try await AuthServiceImpl.shared.createUser(email: email, password: password)
    }
}
