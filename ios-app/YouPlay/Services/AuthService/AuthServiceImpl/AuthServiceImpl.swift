//
//  AuthServiceImpl.swift
//  YouPlay
//
//  Created by Sebastian on 3/15/24.
//
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation
import GoogleSignIn
import GoogleSignInSwift

class AuthServiceImpl: AuthService {
    @Published var userSession: FirebaseAuth.User?

    static let shared = AuthServiceImpl()
    private init() {
        self.userSession = Auth.auth().currentUser
        print("DEBUG: user session id \(userSession?.uid ?? "NO SESSION")")

        if let uid = userSession?.uid {
            Task {
                try await fetchUserMetadata(uid: uid)
            }
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

            _ = try await fetchUserMetadata(uid: result.user.uid)
            print("DEBUG: signed in user \(result.user.uid)")
        } catch {
            print("DEBUG: unable to login user with email \(email) and error: \(error.localizedDescription)")
        }
    }

    @MainActor
    func loginWithGoogle() async throws {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("DEBUG: No clientID found in Firebase configuration")
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // set up popup window
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController
        else {
            print("DEBUG: there is no root view controller")
            return
        }

        do {
            // display OAuth login screen
            let userAuth = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)

            guard let idToken = userAuth.user.idToken else {
                print("DEBUG: no id token found for user, unable to login")
                return
            }

            // create credentials from OAuth credentials
            let accessToken = userAuth.user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)

            let result = try await Auth.auth().signIn(with: credential)
            userSession = result.user
            let uid = result.user.uid

            let existingUserMetadata = try await fetchUserMetadata(uid: uid)
            if existingUserMetadata == nil,
               let email = result.user.email
            {
                print("DEBUG: No metadata found for user with email \(email), creating default data...")
                let username = getUsernameFromEmail(email)
                let newUser = getDefaultUser(username: username, email: email)
                try await uploadUserMetadata(uid: uid, user: newUser)
            }

            _ = try await fetchUserMetadata(uid: uid)
            print("DEBUG: signed in user with Google using email \(result.user.email ?? "unknown") and uid \(result.user.uid)")
        } catch {
            print("DEBUG: unable to sign in with Google", error.localizedDescription)
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

        let username = getUsernameFromEmail(email)
        let newUser = getDefaultUser(username: username, email: email)

        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let uid = result.user.uid
            try await uploadUserMetadata(uid: uid, user: newUser)

            _ = try await fetchUserMetadata(uid: uid)
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

    func resetPassword(email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            print("DEBUG: Password reset email sent to \(email)")
        } catch {
            print("DEBUG: Failed to send password reset email to \(email): \(error.localizedDescription)")
            throw error
        }
    }

    private func getDefaultUser(username: String, email: String) -> User {
        return User(username: username,
                    email: email,
                    likedSongs: [],
                    playlists: [
                        .init(
                            title: "Liked Songs",
                            imageUrl: "https://preview.redd.it/rnqa7yhv4il71.jpg?width=640&crop=smart&auto=webp&s=819eb2bda1b35c7729065035a16e81824132e2f1",
                            songs: []
                        ),
                    ])
    }

    private func uploadUserMetadata(uid: String, user: User) async throws {
        try await UserServiceImpl.shared.updateUserMetadata(uid: uid, user: user)
    }

    private func fetchUserMetadata(uid: String) async throws -> User? {
        return try await UserServiceImpl.shared.getUserMetadata(uid: uid)
    }

    private func getUsernameFromEmail(_ email: String) -> String {
        if !ValidationUtil.isEmail(email) {
            fatalError("DEBUG: unable to create username from an invalid email address!")
        }

        return email.components(separatedBy: "@").first ?? ""
    }
}
