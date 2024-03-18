//
//  SearchView.swift
//  YouPlay
//
//  Created by Sebastian on 3/13/24.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel = SearchViewModel()

    var body: some View {
        Text("Search view!")
            .font(.title)
    }
}

#Preview {
    SearchView(viewModel: SearchViewModel())
}
