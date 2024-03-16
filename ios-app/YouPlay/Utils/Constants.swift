//
//  Constants.swift
//  YouPlay
//
//  Created by Sebastian on 3/15/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

enum FirestoreConstants {
    static let UsersCollection = Firestore.firestore().collection("users")
}

let MIN_PASSWORD_LENGTH = 6
let EMAIL_REGEX = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
