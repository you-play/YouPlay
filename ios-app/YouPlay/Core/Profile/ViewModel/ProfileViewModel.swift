//
//  ProfileViewModel.swift
//  YouPlay
//
//  Created by Sebastian on 3/10/24.
//

import Foundation
import PhotosUI
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var profileImage: Image?
    @Published var selectedItem: PhotosPickerItem? {
        didSet {
            Task {
                try await loadImage()

                // TODO: upload selected profile image
            }
        }
    }

    private func loadImage() async throws {
        guard let item = selectedItem else {
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

        profileImage = Image(uiImage: uiImage)
    }
}
