//
//  User.swift
//  YouPlay
//
//  Created by Sebastian on 3/10/24.
//

import FirebaseFirestoreSwift
import Foundation

struct User: Identifiable, Codable, Hashable {
    // Firestore ID
    @DocumentID var uid: String?

    let username: String
    let email: String

    var id: String {
        return uid ?? NSUUID().uuidString
    }

    var age: Int?
    var gender: Gender?
    var profileImageUrl: String?
}

extension User {
    static let mock = User(
        username: "johndoe",
        email: "jdoe@gmail.com",
        age: 28,
        gender: .male
    )
}

enum Gender: String, Codable {
    case male
    case female
    case other
}
