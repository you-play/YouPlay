//
//  ScrollableSongsView.swift
//  YouPlay
//
//  Created by Joshua lopes on 3/22/24.
//

import SwiftUI

struct ScrollableSongsView: View {
    let playlistTitle: String
    let songs: [Song]
    var body: some View {
        VStack(alignment:.leading){
            Text("Recommended")
                .font(.headline)
                .padding(.leading,15)
                .padding(.top,5)
            ScrollView(.horizontal,showsIndicators: false){
                HStack(spacing: 20){
                    ForEach(songs){song in
                        VStack(alignment: .leading){
                            Image(song.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 120)
                                .clipped()
                                .cornerRadius(8)
                            
                            Text(song.title)
                                .font(.title3)
                                .foregroundColor(.primary)
                                .lineLimit(1)
                            
                            Text(song.artist)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }//Vstack
                        .frame(width:120)
                    }//Foreach
                }//Hstack
                .padding(.horizontal,15)
            }//ScrollView
        }
    }
}

struct ScrollableSongsView_Previews: PreviewProvider {
    static var previews: some View {
        // Your existing setup code for the preview
        let songs = [Song.mockSong, Song.mockSong, Song.mockSong]
        let title = "Recommended"
        ScrollableSongsView(playlistTitle: title, songs: songs)
            .previewLayout(.sizeThatFits) // Optional: Adjusts the size of the preview to fit the content
    }
}
