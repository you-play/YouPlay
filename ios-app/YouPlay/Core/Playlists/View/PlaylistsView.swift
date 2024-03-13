//
//  PlaylistsView.swift
//  YouPlay
//
//  Created by Sebastian on 3/13/24.
//

import SwiftUI

struct PlaylistsView: View {
    @StateObject var viewModel = PlaylistsViewModel()

    var body: some View {
        Text("Playlists view!")
            .font(.title)
    }
}

#Preview {
    PlaylistsView(viewModel: PlaylistsViewModel())
}
