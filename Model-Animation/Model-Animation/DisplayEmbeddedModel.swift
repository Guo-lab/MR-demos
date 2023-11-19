//
//  DisplayEmbeddedModel.swift
//  Model-Animation
//
//  Created by Guo Siqi on 11/19/23.
//

import Foundation
import RealityKit
import SwiftUI
import RealityKitContent

struct DisplayEmbeddedModel: View {
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Model3D(named: "MusicScene") { content in
                    content
                        .resizable().scaledToFit().scaleEffect(1)
                        .phaseAnimator([true, false]) { content, phase in
                            // Rotation is a little bit strange with axis x and y
                            content
                                .perspectiveRotationEffect(.degrees(phase ? 360 : 0), axis: (x: 0, y: 0, z: 20))
                        } animation: { phase in
                            // Opacity is a little bit strange
                            .easeInOut(duration: 18).repeatForever(autoreverses: true)
                        }
                } placeholder: {
                    ProgressView()
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomOrnament) {
                    // Enlarge to full screen
                    Image(systemName: "arrow.up.backward.and.arrow.down.forward.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .font(.largeTitle)
                        .padding()
                    // Share
                    Image(systemName: "square.and.arrow.up.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .font(.largeTitle)
                    Spacer()
                    VStack {
                        Text("PRESTO").font(.extraLargeTitle)
                        Text("Air Zoom Running shoes").foregroundStyle(.secondary)
                    }.padding(.horizontal, 64)
                    Spacer()
                    Button {} label: { Text("Add To Favorite") }
                        .buttonStyle(.borderedProminent)
                        .padding()
                }
            }
        }
    }
}

#Preview {
    DisplayEmbeddedModel()
}
