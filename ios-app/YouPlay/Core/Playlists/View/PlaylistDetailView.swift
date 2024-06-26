//
//  PlaylistDetailView.swift
//  YouPlay
//
//  Created by Heather Browning on 4/4/24.
//

import FirebaseAuth
import SwiftUI

struct PlaylistDetailView: View {
    var playlist: Playlist
    @State var songs: [Song]
    @ObservedObject var spotifyController: SpotifyController

    @State private var searchText = ""
    private var currentUserID: String? {
        Auth.auth().currentUser?.uid
    }

    private var filteredSongs: [Song] {
        if searchText.isEmpty {
            return songs
        } else {
            return songs
                .sorted(by: { song1, song2 in
                    song1.name < song2.name
                })
                .filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        if songs.isEmpty {
            ContentUnavailableView(
                "Whoops! Feels a big empty?",
                systemImage: "music.mic.circle.fill",
                description: Text("Start adding your favorites")
            )
        } else {
            List {
                ForEach(filteredSongs) { song in
                    Button {
                        spotifyController.play(uri: song.uri)
                    } label: {
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
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                            .padding(.leading, 8)
                        }
                    }
                    .tint(.white)
                }
                .onDelete(perform: deleteSong)
            }
            .listStyle(PlainListStyle())
            .navigationTitle(playlist.title)
            .searchable(text: $searchText)
        }
    }

    private func deleteSong(at offsets: IndexSet) {
        guard let userID = currentUserID else {
            print("DEBUG: No user is currently logged in.")
            return
        }

        for offset in offsets {
            let song = filteredSongs[offset] // these are the song actually displayed

            Task {
                await PlaylistServiceImpl.shared.removeSongFromPlaylist(uid: userID, playlistId: playlist.id, songId: song.id)

                // optimistic update
                if let songIndex = self.songs.firstIndex(where: { $0.id == song.id }) {
                    self.songs.remove(at: songIndex)
                }
            }
        }
    }
}
