//
//  Artist.swift
//  YouPlay
//
//  Created by 趙藝鑫 on 3/27/24.
//
import FirebaseFirestoreSwift
import Foundation

struct Artist: Identifiable, Codable, Hashable {
    let id, name: String
}

extension Artist {
    static let mock = Artist(id: "1", name: "Taylor Swift")
}
