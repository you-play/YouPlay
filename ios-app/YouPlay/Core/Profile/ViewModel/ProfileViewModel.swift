//
//  ProfileViewModel.swift
//  YouPlay
//
//  Created by Sebastian on 3/10/24.
//

import Combine
import Foundation
import PhotosUI
import SwiftUI

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var isSaving = false
    @Published var isLoading = false
    @Published var currentUser: User?
    @Published var profileImage: Image?
    @Published var selectedImage: PhotosPickerItem? {
        didSet {
            Task {
                try await loadImage()
            }
        }
    }

    private var selectedImageData: Data?
    private var cancellables = Set<AnyCancellable>()

    init() {
        setUpSubscribers()
    }

    @MainActor
    func saveSelectedImage() {
        isSaving = true

        guard let uid = currentUser?.uid else {
            print("DEBUG: to user logged in, unable to save selected image")
            return
        }

        guard let imageData = selectedImageData else {
            print("DEBUG: no image data, unable to save selected image")
            return
        }

        Task {
            try await UserServiceImpl.shared.updateProfileImage(uid: uid, imageData: imageData)
            _ = try await UserServiceImpl.shared.getUserMetadata(uid: uid) // refresh image

            // reset
            selectedImage = nil
            selectedImageData = nil
            isSaving = false
        }
    }

    private func loadImage() async throws {
        guard let item = selectedImage else {
            print("DEBUG: no selected item, unable to load image")
            return
        }

        guard let imageData = try await item.loadTransferable(type: Data.self) else {
            print("DEBUG: unable to load image data")
            return
        }

        guard let uiImage = UIImage(data: imageData) else {
            print("DEBUG: unable to create UIImage")
            return
        }

        selectedImageData = imageData
        profileImage = Image(uiImage: uiImage)
    }

    private func setUpSubscribers() {
        UserServiceImpl.shared.$currentUser.sink { [weak self] currentUser in
            self?.currentUser = currentUser
        }
        .store(in: &cancellables)
    }
}
