//
//  Canvas_GANApp.swift
//  Canvas-GAN
//
//  Created by Guo Siqi on 11/17/23.
//

import SwiftUI

@main
struct Canvas_GANApp: App {
    
    /* The state wrapper tells the app to persist the instance of view model */
    @State private var viewModel = ViewModel()
    
    var body: some Scene {
        
        /* launch the first scene by default */
        WindowGroup {
            ContentView()
                .environment(viewModel) // inject the view model
        }.windowStyle(.plain)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
                .environment(viewModel)
        }
        
        WindowGroup(id: "doodle_canvas") {
            DoodleView()
                .environment(viewModel)
        }
    }
}
