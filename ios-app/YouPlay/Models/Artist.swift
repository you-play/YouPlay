//
//  Artist.swift
//  YouPlay
//
//  Created by 趙藝鑫 on 3/27/24.
//
import FirebaseFirestoreSwift
import Foundation

struct Artist: Codable, Hashable {
    let href, id, name: String
}
extension Artist {
    static let mock = Artist(
        href: "swiftPage",
        id: "artist123456",
        name: "Swift"

    )
}
