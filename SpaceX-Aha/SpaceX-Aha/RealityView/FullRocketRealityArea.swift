//
//  FullRocketRealityArea.swift
//  SpaceX-Aha
//
//  Created by Guo Siqi on 11/20/23.
//

import SwiftUI
import RealityKit
import RealityKitContent


struct FullRocketRealityArea: View {
    @State private var  audioController: AudioPlaybackController?
    
    var body: some View {
        RealityView { content in
            guard let fullEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) else {
                fatalError("Unable to load scene model")
            }
            // print(fullEntity.debugDescription)
            
            let ambientAudioEntity = fullEntity.findEntity(named: "AmbientAudio")
            guard let resource = try? await AudioFileResource(named: "/Root/Space_wav", from: "Immersive.usda", in: realityKitContentBundle) else {
                fatalError("Unable to load space.wav file")
            }
            ambientAudioEntity?.ambientAudio?.gain = -10;
            audioController = ambientAudioEntity?.prepareAudio(resource)
            audioController?.play()
            
            content.add(fullEntity)
        }
        .onDisappear(perform: {
            audioController?.stop() // important to pause
        })
    }
}



/* Please make sure this immersive Space could be loaded at first with 2 spheres in Preview Mode */
#Preview {
    FullRocketRealityArea()
        .environment(ViewModel())
}
