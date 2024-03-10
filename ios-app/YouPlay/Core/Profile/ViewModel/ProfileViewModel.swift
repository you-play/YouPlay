//
//  ProfileViewModel.swift
//  YouPlay
//
//  Created by Sebastian on 3/10/24.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var user: User?

    private let userService: UserService

    init(userService: UserService) {
        self.userService = userService
        self.user = userService.currentUser
    }
}
