//
//  RootViewModel.swift
//  YouPlay
//
//  Created by Sebastian on 3/16/24.
//

import Combine
import Firebase
import FirebaseAuth
import Foundation

class RootViewModel: ObservableObject {
    @Published var currentUser: User?

    private var cancellables = Set<AnyCancellable>()

    init() {
        setupSubscribers()
    }

    private func setupSubscribers() {
        UserServiceImpl.shared.$currentUser.sink { [weak self] currentUser in
            self?.currentUser = currentUser
        }
        .store(in: &cancellables)
    }
}
