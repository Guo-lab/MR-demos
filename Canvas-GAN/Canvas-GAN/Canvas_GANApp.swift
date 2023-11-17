//
//  Canvas_GANApp.swift
//  Canvas-GAN
//
//  Created by Guo Siqi on 11/17/23.
//

import SwiftUI

@main
struct Canvas_GANApp: App {
    var body: some Scene {
        /* launch the first scene by default */
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
