//
//  TabBar.swift
//  YouPlay
//
//  Created by Sebastian on 3/13/24.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            PlaylistsView()
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
    TabBarView()
}
