//
//  SongDetailView.swift
//  YouPlay
//
//  Created by Joshua lopes on 3/22/24.
//

import SwiftUI

struct SongDetailView: View {
    @State private var songProgress: Double = 0.0
    @State private var isLiked: Bool = false
    @State private var isPaused: Bool = false
    
    var body: some View {
        VStack{
            Image("testSpotifyImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width:350 , height: 350)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .clipped()
            
            HStack{
                VStack(alignment:.leading){
                    Text("Song Name")
                        .font(.system(size: 18,weight: .bold))
                    Text("Arist")
                }
                Spacer()
                //Like button
                Button(action:{
                    isLiked.toggle()
                }){
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(isLiked ? .green : .white)
                        .imageScale(.large)
                }
            }
            .padding()
            
            Slider(value: $songProgress, in: 0...1,step: 0.01)
                .accentColor(.green)
            
            //Playback controlls
            
            HStack{
                //Prev
                Button(action:{
                    //Go to prev song
                }){
                    Image(systemName: "backward.end")
                        .foregroundColor(.green)
                        .font(.system(size: 40))
                }
                
                //play/pause
                 Button(action:{
                    //pause or play song
                     isPaused.toggle()
                }){
                    Image(systemName: isPaused ? "play.circle" : "pause.circle")
                        .foregroundColor(.green)
                        .font(.system(size: 60))
                }
                
                //next song
                Button(action:{
                    //pause or play song
                }){
                    Image(systemName: "forward.end")
                        .foregroundColor(.green)
                        .font(.system(size:40))
                }
                
            }
            .font(.title)
            .padding(.top,20)
        }
        .padding()
    }
}

#Preview {
    SongDetailView()
}
