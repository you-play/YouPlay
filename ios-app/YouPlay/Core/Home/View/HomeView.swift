//
//  HomeView.swift
//  YouPlay
//
//  Created by Sebastian on 3/13/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()

    var body: some View {
        Text("Home view!")
            .font(.title)
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel())
}
