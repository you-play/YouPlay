//
//  PlaylistListView.swift
//  YouPlay
//
//  Created by Sebastian on 4/1/24.
//

import SwiftUI

struct PlaylistListView: View {
    var playlists: [Playlist]

    /// A callback function that's called when a row is tapped.
    var action: (Playlist) -> Void

    var body: some View {
        ForEach(playlists) { playlist in
            Button {
                action(playlist)
            } label: {
                // TODO: Playlist row stuff
                Text(playlist.title)
            }
            .tint(.white)
        }
    }
}

#Preview {
    PlaylistListView(playlists: Playlist.mocks) { playlist in
        print(playlist.title)
    }
}
