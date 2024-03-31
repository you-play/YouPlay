//
//  SongDetailView.swift
//  YouPlay
//
//  Created by Joshua lopes on 3/22/24.
//

import SwiftUI

struct SongDetailView: View {
    @ObservedObject var viewModel: RootViewModel

    var body: some View {
        VStack {
            Image(viewModel.song?.imageName ?? "testSpotifyImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: 400)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .clipped()
                .padding(.bottom, 20)
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(viewModel.song?.title ?? "Song title unavailable")
                        .font(.title2)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    
                    Text(viewModel.song?.artists.joined(separator: ", ") ?? "Artist(s) unavailable")
                        .foregroundStyle(.gray)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Like button
                Button(action: {
                    viewModel.isLiked.toggle()
                    // TODO: add like functionality
                    print(viewModel.isLiked ? "Liked song" : "Unliked song")
                }) {
                    Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 25, height: 25)
                        .foregroundColor(viewModel.isLiked ? .green : .white)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
            
            // playback controlls
            HStack(spacing: 50) {
                // prev
                Button(action: {
                    // TODO: go to prev song
                    print("Previous song")
                }) {
                    Image(systemName: "backward.end.fill")
                        .foregroundColor(.primary)
                        .font(.system(size: 30))
                }
                
                // play/pause
                Button(action: {
                    viewModel.isPaused.toggle()
                    // TODO: play/pause song
                    print(viewModel.isPaused ? "Pause song" : "Play song")
                }) {
                    Image(systemName: viewModel.isPaused ? "play.circle.fill" : "pause.circle.fill")
                        .foregroundColor(.primary)
                        .font(.system(size: 60))
                }
                
                // next song
                Button(action: {
                    // TODO: skip song
                    print("Next song")
                }) {
                    Image(systemName: "forward.end.fill")
                        .foregroundColor(.primary)
                        .font(.system(size: 30))
                }
            }
            .font(.title)
            .padding(.top, 20)
        }
        .padding()
    }
}

#Preview {
    SongDetailView(viewModel: RootViewModel())
}