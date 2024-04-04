//
//  PlaylistServiceImpl.swift
//  YouPlay
//
//  Created by Sebastian on 4/1/24.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class PlaylistServiceImpl: PlaylistService {
    static let shared = PlaylistServiceImpl()
    
    private init() {}
    
    /// Sets up the default playlists for a given user's id.
    func setupDefaultPlaylists(uid: String) async {
        let playlistsRef = FirestoreConstants.PlaylistsCollection(uid: uid)
        
        do {
            for playlist in DEFAULT_PLAYLISTS {
                let encodedDefaultPlaylists = try Firestore.Encoder().encode(playlist)
                
                try await playlistsRef.document().setData(encodedDefaultPlaylists)
                print("DEBUG: set up default playlist \(playlist.title) for user \(uid)")
            }
        } catch {
            print("DEBUG: unable to setup default playlists for user \(uid)", error.localizedDescription)
        }
    }
    
    /// Retrieves the playlists in ascending alphabetical order for a given user.
    func getPlaylists(uid: String) async -> [Playlist] {
        let playlistsRef = FirestoreConstants.PlaylistsCollection(uid: uid)
        
        var playlists: [Playlist] = []
        do {
            let snapshot = try await playlistsRef
                .order(by: "title") // Sort playlists alphabetically by title
                .getDocuments()
            
            playlists = snapshot.documents
                .compactMap { document in
                    try? document.data(as: Playlist.self)
                }
            
        } catch {
            print("DEBUG: unable to get playlists for user \(uid)", error.localizedDescription)
        }
        
        return playlists
    }
    
    /// Retrieves an individual playlist and its data for a given user.
    ///
    /// Note: returns `nil` is the playlist was not found.
    func getPlaylist(uid: String, playlistId: String) async -> Playlist? {
        let playlistsRef = FirestoreConstants.PlaylistsCollection(uid: uid)
        
        var playlist: Playlist? = nil
        do {
            playlist = try await playlistsRef.document(playlistId).getDocument(as: Playlist.self)
        } catch {
            print("DEBUG: unable to get playlists for user \(uid)", error.localizedDescription)
        }
        
        return playlist
    }
    
    /// Retrieves the top X (`limit`) playlists in descending order by `lastModified` for a given user.
    func getTopPlaylists(uid: String, limit: Int) async -> [Playlist] {
        let playlistsRef = FirestoreConstants.PlaylistsCollection(uid: uid)
        
        var playlists: [Playlist] = []
        do {
            let snapshot = try await playlistsRef
                .order(by: "lastModified", descending: true)
                .limit(to: limit)
                .getDocuments()
            
            playlists = snapshot.documents
                .compactMap { document in
                    try? document.data(as: Playlist.self)
                }
        } catch {
            print("DEBUG: unable to get top 6 playlists for user \(uid)", error.localizedDescription)
        }
        
        return playlists
    }
    
    // Function to create a new playlist for a given user
    func createPlaylist(uid: String, name: String) async {
        let playlistsRef = FirestoreConstants.PlaylistsCollection(uid: uid)
        let newPlaylist = Playlist(title: name, songs: [], imageUrl: nil)
        do {
            let _ = try await playlistsRef.addDocument(from: newPlaylist)
            print("DEBUG: Created new playlist \(name) for user \(uid)")
        } catch {
            print("DEBUG: Unable to create new playlist for user \(uid)", error.localizedDescription)
        }
    }
    
    // Function to delete a playlist for a given user
    func deletePlaylist(uid: String, playlistId: String) async {
        let playlistsRef = FirestoreConstants.PlaylistsCollection(uid: uid)
        do {
            try await playlistsRef.document(playlistId).delete()
            print("DEBUG: Deleted playlist \(playlistId) for user \(uid)")
        } catch {
            print("DEBUG: Unable to delete playlist \(playlistId) for user \(uid)", error.localizedDescription)
        }
    }
    func removeSongFromPlaylist(uid: String, playlistId: String, songId: String) async {
        let db = Firestore.firestore()
        let playlistRef = db.collection("playlists").document(playlistId)
        
        do {
            try await playlistRef.updateData([
                "songs": FieldValue.arrayRemove([songId])
            ])
            print("DEBUG: Removed song \(songId) from playlist \(playlistId)")
        } catch {
            print("DEBUG: Failed to remove song from playlist", error)
        }
    }
}
