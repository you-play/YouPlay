//
//  PlaylistsView.swift
//  YouPlay
//
//  Created by Sebastian on 3/13/24.
//

import SwiftUI

struct PlaylistsView: View {
    @StateObject var viewModel = PlaylistsViewModel()
    @ObservedObject var spotifyController: SpotifyController

    @State private var showingCreatePlaylistSheet = false
    @State private var newPlaylistName = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.playlists) { playlist in
                    NavigationLink(destination:
                        PlaylistDetailView(playlist: playlist,
                                           songs: viewModel.fetchSongsForPlaylist(playlistId: playlist.id),
                                           spotifyController: spotifyController))
                    {
                        HStack {
                            if let imageUrl = playlist.imageUrl, let url = URL(string: imageUrl) {
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
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            } else {
                                Image(systemName: "music.note.list")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .background(Color.gray)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            VStack(alignment: .leading) {
                                Text(playlist.title)
                                    .font(.headline)
                                Text("\(playlist.songs.count) songs")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.leading, 8)
                        }
                    }
                }
                .onDelete(perform: deletePlaylist)
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Playlists")
            .toolbar {
                Button(action: {
                    self.showingCreatePlaylistSheet = true
                }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingCreatePlaylistSheet) {
                NavigationView {
                    Form {
                        TextField("Playlist Name", text: $newPlaylistName)
                        Button("Create") {
                            Task {
                                await viewModel.createPlaylist(withName: newPlaylistName)
                                // Reset the name for next use
                                newPlaylistName = ""
                                showingCreatePlaylistSheet = false
                            }
                        }
                        .disabled(newPlaylistName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    .navigationTitle("New Playlist")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                showingCreatePlaylistSheet = false
                                // Reset the name for next use
                                newPlaylistName = ""
                            }
                        }
                    }
                }
            }
        }
    }

    private func deletePlaylist(at offsets: IndexSet) {
        for offset in offsets {
            let playlist = viewModel.playlists[offset]
            Task {
                await viewModel.deletePlaylist(playlistId: playlist.id)
            }
        }
        viewModel.playlists.remove(atOffsets: offsets)
    }
}
