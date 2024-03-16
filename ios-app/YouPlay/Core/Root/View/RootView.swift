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
            if viewModel.userSession == nil {
                AuthView()
            } else {
                TabBarView()
            }
        }
    }
}

#Preview {
    RootView()
}
