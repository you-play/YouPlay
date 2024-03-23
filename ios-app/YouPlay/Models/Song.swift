//
//  Song.swift
//  YouPlay
//
//  Created by Joshua lopes on 3/22/24.
//

import Foundation
import FirebaseFirestoreSwift

struct Song: Identifiable,Codable,Hashable{
    @DocumentID var UUID:String?
    
    let title: String
    let artist: String
    let imageName : String // will probable need to change to imageURL
    
    var id: String{
        return UUID ?? NSUUID().uuidString
    }
}

extension Song{
    static let mockSong = Song(
        title: "Title",
        artist: "Artist",
        imageName: "testSpotifyImage"
        )
}
