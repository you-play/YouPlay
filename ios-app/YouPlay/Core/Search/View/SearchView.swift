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
        VStack {
            ZStack {
                // Background and search icon
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(.systemGray6))
                    .frame(height: 48)

                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                        .padding(.leading, 5)
                        .imageScale(.large)
                    TextField("Search...", text: $viewModel.searchQuery)
                        .padding(.vertical, 10)
                        .padding(.leading, 10)
                        .foregroundColor(.white)

                    Spacer()
                }
                .padding(.horizontal, 10)
            }
            .padding()
            .onChange(of: viewModel.searchQuery) { newValue in
                Task {
                    await viewModel.searchSongs(query: newValue)
                }
            }

            List(viewModel.searchResults?.tracks?.items ?? [], id: \.id) { item in
                HorizontalSongView(song: item)
            }
            .listStyle(PlainListStyle())
        }
        .navigationBarTitle(Text("Search"), displayMode: .inline)
    }
}

#Preview {
    SearchView(viewModel: SearchViewModel())
}
