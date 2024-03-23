//
//  SongDetailView.swift
//  YouPlay
//
//  Created by Joshua lopes on 3/22/24.
//

import SwiftUI

struct SongDetailView: View {
    // TODO: eventually it will make more sense to simply pass in a `Song` and `Artist` models to have all relevant info
    let songName: String
    let artistNames: [String]
    
    // @State private var songProgress: Double = 0.33
    @State private var isLiked: Bool = false
    @State private var isPaused: Bool = true
    
    var body: some View {
        VStack {
            Image("testSpotifyImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: 350)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .clipped()
                .padding(.bottom, 20)
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(songName)
                        .font(.title2)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    
                    Text(artistNames.joined(separator: ", "))
                        .foregroundStyle(.gray)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Like button
                Button(action: {
                    isLiked.toggle()
                    // TODO: add like functionality
                    print(isLiked ? "Liked song" : "Unliked song")
                }) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 25, height: 25)
                        .foregroundColor(isLiked ? .green : .white)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
            
            // Slider(value: $songProgress, in: 0 ... 1, step: 0.01)
            //     .accentColor(.green)
            
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
                    isPaused.toggle()
                    // TODO: play/pause song
                    print(isPaused ? "Pause song" : "Play song")
                }) {
                    Image(systemName: isPaused ? "play.circle.fill" : "pause.circle.fill")
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
    SongDetailView(
        songName: "Some super super long song name",
        artistNames: ["Artist 1", "Artist 2"]
    )
}
