//
//  StorageServiceImpl.swift
//  YouPlay
//
//  Created by Sebastian on 3/16/24.
//

import FirebaseStorage
import Foundation

/// An Singleton implementation of the `StorageService` based around `Firebase Storage`
class StorageServiceImpl: StorageService {
    private init() {}
    static let shared = StorageServiceImpl()

    private let storageRef = Storage.storage().reference()

    /// Uploads an image and returns the public link (URL) to access the uploaded file.
    ///
    /// Images are uploaded to a specified `bucket` in Firebase Storage with the given `fileName`
    /// (without an extension) and the `imageData`.
    func uploadImage(bucket: StorageBuckets, fileName: String, imageData: Data, fileExtension: ImageFileExtension = .jpg)
        async throws -> String
    {
        let fileNameWithExtension = "\(fileName)\(fileExtension.rawValue)"
        let imageRef = storageRef.child("\(bucket.rawValue)/\(fileNameWithExtension)")

        let metadata = StorageMetadata()
        metadata.contentType = "image/\(fileExtension.fullName)"

        do {
            _ = try await imageRef.putDataAsync(imageData, metadata: metadata)
            print("DEBUG: successfully uploaded image with name \(fileNameWithExtension)")

            let downloadURL = try await imageRef.downloadURL()
            print("DEBUG: image download URL for filename \(fileNameWithExtension): \(downloadURL.absoluteString)")
            return downloadURL.absoluteString
        } catch {
            print("DEBUG: error uploading image with name \(fileNameWithExtension): \(error.localizedDescription)")
            throw error
        }
    }
}

enum ImageFileExtension: String {
    case jpg = ".jpg"
    case png = ".png"

    var fullName: String {
        switch self {
        case .jpg: return "jpeg"
        case .png: return "png"
        }
    }
}
