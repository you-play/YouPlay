//
//  PlaylistDetailView.swift
//  YouPlay
//
//  Created by Heather Browning on 4/4/24.
//

import SwiftUI
import FirebaseAuth

struct PlaylistDetailView: View {
    let playlist: Playlist
//    @State private var songs: [Song] = []
    @State private var songs: [Song] = Song.mocks
    private var currentUserID: String? {
        Auth.auth().currentUser?.uid
    }
    var body: some View {
        List {
            ForEach(songs) { song in
                HStack {
                    // Display album cover
                    if let imageUrl = song.album.images.first?.url, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image.resizable().aspectRatio(contentMode: .fill)
                            case .failure:
                                Image(systemName: "photo")
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    } else {
                        Image(systemName: "music.note")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .background(Color.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    VStack(alignment: .leading) {
                        Text(song.name)
                            .font(.headline)
                        Text(song.artists.map { $0.name }.joined(separator: ", "))
                            .font(.subheadline)
                    }
                    .padding(.leading, 8)
                }
            }
            .onDelete(perform: deleteSong)
                
            }
            .listStyle(PlainListStyle())
            .navigationTitle(playlist.title)
            .onAppear {
                //            fetchSongs()
            }
        }
    private func deleteSong(at offsets: IndexSet) {
        guard let userID = currentUserID else {
            print("DEBUG: No user is currently logged in.")
            return
        }
            for offset in offsets {
                let song = songs[offset]
                Task {
                    await PlaylistServiceImpl.shared.removeSongFromPlaylist(uid: userID, playlistId: playlist.id, songId: song.id)
                    songs.remove(at: offset)
                }
            }
    }
    
//    private func fetchSongs() {
//        Task {
//            let fetchedSongs = await SpotifyServiceImpl.shared.fetchSongs(byIds: playlist.songs)
//            songs = fetchedSongs ?? []
//        }
//    }
}