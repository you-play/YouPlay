//
//  UserServiceImpl.swift
//  YouPlay
//
//  Created by Sebastian on 3/10/24.
//

import Foundation

class UserServiceImpl: UserService {
    private init() {}
    static let shared = UserServiceImpl()

    @Published var currentUser: User? = User.mock
}
