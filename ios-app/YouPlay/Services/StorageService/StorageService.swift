//
//  StorageService.swift
//  YouPlay
//
//  Created by Sebastian on 3/16/24.
//

import Foundation

/// The `StorageService` manages all communication between the app and our Object Storage.
protocol StorageService {
    func uploadImage(bucket: StorageBucket, fileName: String, imageData: Data, fileExtension: ImageFileExtension)
        async throws -> String
}
