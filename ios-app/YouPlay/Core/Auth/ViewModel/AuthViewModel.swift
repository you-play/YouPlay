//
//  AuthViewModel.swift
//  YouPlay
//
//  Created by Sebastian on 3/16/24.
//

import Combine
import Foundation
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""

    @Published var isLoading: Bool = false

    func login() async throws {
        isLoading = true
        print("DEBUG: attemping to login user with email \(email)")
        try await AuthServiceImpl.shared.login(email: email, password: password)
        isLoading = false
    }

    func signUp() async throws {
        isLoading = true
        print("DEBUG: attemping to create user with email \(email)")
        try await AuthServiceImpl.shared.createUser(email: email, password: password)
        isLoading = false
    }

    func resetPassword() async throws {
        isLoading = true
        if !ValidationUtil.isEmail(email) {
            print("DEBUG: unable to reset password with an invalid email")
            isLoading = false
            return
        }

        try await AuthServiceImpl.shared.resetPassword(email: email)

        isLoading = false
    }

    func reset() {
        email = ""
        password = ""
    }
}
