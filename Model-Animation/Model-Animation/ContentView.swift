//
//  ContentView.swift
//  Model-Animation
//
//  Created by Guo Siqi on 11/19/23.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    var body : some View {
        VStack {
            DisplayEmbeddedModel()
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
