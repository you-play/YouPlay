//
//  TabBar.swift
//  YouPlay
//
//  Created by Sebastian on 3/13/24.
//

import SwiftUI

struct TabBarView: View {
    @ObservedObject var spotifyController: SpotifyController
    
    var body: some View {
        TabView {
            HomeView(spotifyController: spotifyController)
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            SearchView(spotifyController: spotifyController)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            PlaylistsView(spotifyController: spotifyController)
                .tabItem {
                    Label("Playlists", systemImage: "music.note.list")
                }
        }
        .tint(.green)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()

            UITabBar.appearance().standardAppearance = appearance
        }
    }
}

#Preview {
    TabBarView(spotifyController: SpotifyController())
}
