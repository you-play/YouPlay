//
//  User.swift
//  YouPlay
//
//  Created by Sebastian on 3/10/24.
//

import Foundation

struct User: Identifiable {
    var id: Int
    var firstName: String
    var lastName: String
}

extension User {
    static let mock = User(id: 1, firstName: "John", lastName: "Doe")
}
