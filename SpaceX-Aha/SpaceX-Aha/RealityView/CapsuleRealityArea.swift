//
//  CapsuleRealityArea.swift
//  SpaceX-Aha
//
//  Created by Guo Siqi on 11/20/23.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct CapsuleRealityArea: View {
    var body: some View {
        // In front of the window
        RealityView { content in
            guard let capsuleEntity = try? await Entity(named: "Scene", in: realityKitContentBundle) else {
                fatalError("Unable to load scene model")
            }
            content.add(capsuleEntity)
        }
    }
}

#Preview {
    CapsuleRealityArea()
}
