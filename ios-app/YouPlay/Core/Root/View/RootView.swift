//
//  ContentView.swift
//  YouPlay
//
//  Created by Sebastian on 3/10/24.
//

import SwiftUI

struct RootView: View {
    @StateObject private var viewModel = RootViewModel()

    var body: some View {
        Group {
            if viewModel.currentUser == nil {
                AuthView()
            } else {
                NavigationStack {
                    TabBarView()
                        .toolbar { // Global toolbar
                            ToolbarItem(placement: .topBarLeading) {
                                if let user = viewModel.currentUser {
                                    NavigationLink(
                                        destination: ProfileView(),
                                        label: {
                                            CircularProfileImageView(user: user, size: .small)
                                        }
                                    )
                                }
                            }
                        }
                }
                .tint(.green)
            }
        }
    }
}

#Preview {
    RootView()
}
