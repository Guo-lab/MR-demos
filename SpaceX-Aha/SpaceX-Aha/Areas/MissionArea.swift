//
//  MissonArea.swift
//  SpaceX-Aha
//
//  Created by Guo Siqi on 11/20/23.
//

import SwiftUI
import AVKit

// Add AVKIT Framework to play the video
//      in Project > TARGETS > Build Phases > Copy Bundle  Resources
//      Add the sources
struct MissionArea: View {
    
    @State private var player = AVPlayer(url: Bundle.main.url(forResource: "Inspiration4", withExtension: "mp4")!)
    @State private var isPlaying: Bool = false
    
    var body: some View {
        VStack {
            VideoPlayer(player: player)
            Button {
                isPlaying ? player.pause() : player.play()
                isPlaying.toggle()
                player.seek(to: .zero)
            } label: {
                Image(systemName: isPlaying ? "stop" : "play")
                    .padding(5)
                Text(isPlaying ? "Pause" : "Replay")
            }
            .padding(10)
        }
        .glassBackgroundEffect()
        .onAppear(perform: { isPlaying = false })
        .onDisappear(perform: {
            player.pause()
        })
    }
}

#Preview {
    MissionArea()
        .environment(ViewModel())
}
