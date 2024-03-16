//
//  AuthServiceImpl.swift
//  YouPlay
//
//  Created by Sebastian on 3/15/24.
//
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class AuthServiceImpl: AuthService {
    @Published var userSession: FirebaseAuth.User?

    static let shared = AuthServiceImpl()
    private init() {
        self.userSession = Auth.auth().currentUser
        print("DEBUG: user session id \(userSession?.uid ?? "NO SESSION")")

        if let uid = userSession?.uid {
            fetchUserMetadata(uid: uid)
        }
    }

    func login(email: String, password: String) async throws {
        if let user = userSession {
            print("DEBUG: user is already logged in with email \(user.email!)")
            return
        }

        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            userSession = result.user

            fetchUserMetadata(uid: result.user.uid)
            print("DEBUG: signed in user \(result.user.uid)")
        } catch {
            print("DEBUG: unable to login user with email \(email) and error: \(error.localizedDescription)")
        }
    }

    func createUser(email: String, password: String) async throws {
        if !ValidationUtil.isEmail(email) {
            print("DEBUG: Unable to create user, invalid email address!")
            return
        }

        if !ValidationUtil.isValidPassword(password) {
            print("DEBUG: Unable to create user, password must be at least \(MIN_PASSWORD_LENGTH) characters long")
            return
        }

        let username = email.components(separatedBy: "@").first ?? ""
        let newUser = User(username: username, email: email)

        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            userSession = result.user

            uploadUserMetadata(uid: result.user.uid, user: newUser)
            print("DEBUG: created user \(result.user.uid)")
        } catch {
            print("DEBUG: unable to create user with email \(email) and error: \(error.localizedDescription)")
        }
    }

    func logout() {
        if userSession == nil {
            print("DEBUG: unable to logout without a userSession")
            return
        }

        do {
            try Auth.auth().signOut()

            userSession = nil
            UserServiceImpl.shared.currentUser = nil
            print("DEBUG: logged out user")
        } catch {
            print("DEBUG: unable to log out user with email \(userSession?.email ?? "NO EMAIL") with error \(error.localizedDescription)")
        }
    }

    private func uploadUserMetadata(uid: String, user: User) {
        Task {
            try await UserServiceImpl.shared.updateUserMetadata(uid: uid, user: user)
        }
    }

    private func fetchUserMetadata(uid: String) {
        Task {
            try await UserServiceImpl.shared.getUserMetadata(uid: uid)
        }
    }
}
