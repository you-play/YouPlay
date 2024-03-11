//
//  UserServiceImpl.swift
//  YouPlay
//
//  Created by Sebastian on 3/10/24.
//

import Foundation

class MockUserService: UserService {
    @Published var currentUser: User? = User.mock
}
