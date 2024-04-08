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
        
        do {
            let snapshot = try await playlistsRef
                .order(by: "lastModified", descending: true)
                .getDocuments()
            
            let playlists = snapshot.documents
                .compactMap { document in
                    try? document.data(as: Playlist.self)
                }
                .filter { !$0.songs.isEmpty }
                .prefix(limit)
            
            return Array(playlists)
        } catch {
            print("DEBUG: unable to get top 6 playlists for user \(uid)", error.localizedDescription)
        }
        
        return []
    }
    
    // Function to create a new playlist for a given user
    func createPlaylist(uid: String, name: String) async {
        if name.lowercased() == LIKED_SONGS.lowercased() {
            print("DEBUG: Cannot add a song that is labeled Liked Songs")
            return
        }
        let playlistsRef = FirestoreConstants.PlaylistsCollection(uid: uid)
        
        let newPlaylist = Playlist(title: name, songs: [], imageUrl: nil)
        do {
            let _ = try playlistsRef.addDocument(from: newPlaylist)
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
        let playlistRef = FirestoreConstants.PlaylistsCollection(uid: uid).document(playlistId)
        
        do {
            try await playlistRef.updateData([
                "songs": FieldValue.arrayRemove([songId])
            ])
            print("DEBUG: Removed song \(songId) from playlist \(playlistId)")
        } catch {
            print("DEBUG: Failed to remove song from playlist", error)
        }
    }
    
    /// Retrieves the full `Song` metadata for a list of `Playlists` as a mapping: playlistId -> Song[]
    @MainActor
    func getPlaylistIdToSongsMap(for playlists: [Playlist]) async -> [String: [Song]] {
        var playlistIdToSongs: [String: [Song]] = [:]
        
        for playlist in playlists {
            var songs: [Song] = []
                
            for songId in playlist.songs {
                if let song = await SpotifyServiceImpl.shared.getSongDetails(id: songId) {
                    songs.append(song)
                }
            }
                    
            playlistIdToSongs[playlist.id] = songs
        }
        
        return playlistIdToSongs
    }

    /// Toggles the "liked" status for a particular song.
    @MainActor
    func toggleLikedStatus(uid: String, song: Song, isLiked: Bool) async {
        let playlistsRef = FirestoreConstants.PlaylistsCollection(uid: uid)
        
        do {
            let querySnapshot = try await playlistsRef.whereField("title", isEqualTo: LIKED_SONGS).getDocuments()
            var playlistId = querySnapshot.documents.first?.documentID
            
            if playlistId == nil {
                print("DEBUG: liked songs playlist not found!")
                playlistId = await createEmptyLikedPlaylist(uid: uid)
            }
            
            guard let playlistId = playlistId else {
                print("DEBUG: Liked songs playlist not found for user \(uid) and was unable to create it")
                return
            }
            
            if isLiked {
                await removeSongFromPlaylist(uid: uid, playlistId: playlistId, songId: song.id)
            } else {
                await addSongToPlaylist(uid: uid, playlistId: playlistId, song: song)
            }
            
        } catch {
            print("DEBUG: Unable to add song \(song.id) to Liked Songs playlist for user \(uid)", error.localizedDescription)
        }
    }
    
    func isLikedSong(uid: String, songId: String) async -> Bool {
        let playlistRef = FirestoreConstants.PlaylistsCollection(uid: uid)
        
        do {
            let querySnapshot = try await playlistRef.whereField("title", isEqualTo: LIKED_SONGS).getDocuments()
            guard let playlist = try querySnapshot.documents.first?.data(as: Playlist.self) else {
                print("DEBUG: Liked songs playlist not found for user \(uid)")
                return false
            }
            
            if playlist.songs.firstIndex(of: songId) != nil {
                return true
            }
        } catch {
            print("DEBUG: Unable to add song \(songId) to Liked Songs playlist for user \(uid)", error.localizedDescription)
        }
        
        return false
    }
    
    func addSongToPlaylist(uid: String, playlistId: String, song: Song) async {
        let playlistRef = FirestoreConstants.PlaylistsCollection(uid: uid).document(playlistId)
        
        do {
            var playlist = try await playlistRef.getDocument(as: Playlist.self)
            var uniqueSongs: Set<String> = Set(playlist.songs)
            
            if uniqueSongs.contains(song.id) {
                print("DEBUG: song \(song.id) already exists in playlist \(playlistId) for user \(uid)")
                return
            } else {
                uniqueSongs.insert(song.id)
            }
            
            playlist.songs = Array(uniqueSongs)
            playlist.lastModified = Timestamp()
            
            if playlist.title != LIKED_SONGS {
                playlist.imageUrl = song.album.images.first?.url
            }
            
            let encodedPlaylist = try Firestore.Encoder().encode(playlist)
            try await playlistRef.setData(encodedPlaylist)
            print("DEBUG: Added song \(song.id) to playlist \(playlistId) for user \(uid)")
        } catch {
            print("DEBUG: Unable to add song \(song.id) to playlist \(playlistId) for user \(uid)", error.localizedDescription)
        }
    }
    
    /// Creates an empty liked playlist for a given user and returns the document id the newly
    /// created playlist.
    private func createEmptyLikedPlaylist(uid: String) async -> String? {
        let playlistsRef = FirestoreConstants.PlaylistsCollection(uid: uid)
        
        do {
            let likedPlaylist = DEFAULT_PLAYLISTS.first { $0.title == LIKED_SONGS }
            let encodedPlaylist = try Firestore.Encoder().encode(likedPlaylist)
                
            let playlistId = playlistsRef.document().documentID
            try await playlistsRef.document(playlistId).setData(encodedPlaylist)
            
            print("DEBUG: create empty liked playlist for uid \(uid)")
            return playlistId
        } catch {
            print("DEBUG: unable to create liked songs playlists for user \(uid)", error.localizedDescription)
        }
        
        return nil
    }
}
