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
    @Published var userSession: FirebaseAuth.User?

    private var cancellables = Set<AnyCancellable>()

    init() {
        setupSubscribers()
    }

    private func setupSubscribers() {
        AuthServiceImpl.shared.$userSession.sink { [weak self] userSession in
            self?.userSession = userSession
        }
        .store(in: &cancellables)
    }
}
