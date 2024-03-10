//
//  UserService.swift
//  YouPlay
//
//  Created by Sebastian on 3/10/24.
//

import Foundation

/// The `UserService` manages all internal user metadata.
protocol UserService {
    /// The currently logged-in user.
    var currentUser: User? { get set }
}
