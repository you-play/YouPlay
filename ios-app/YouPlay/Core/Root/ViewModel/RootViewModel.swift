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

    // TODO: we will need to manage liking and pause/play functionality
    @Published var song: Song? = Song.mock
    @Published var isPaused: Bool = true
    @Published var isLiked: Bool = true

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
