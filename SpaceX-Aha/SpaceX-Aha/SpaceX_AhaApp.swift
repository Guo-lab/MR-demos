//
//  SpaceX_AhaApp.swift
//  SpaceX-Aha
//
//  Created by Guo Siqi on 11/19/23.
//

import SwiftUI

/* main denotes the APP ENTRY POINT */
@main
struct SpaceX_AhaApp: App {
    var body: some Scene {
        // Apply different styles, positioning, and UINTS
        // e.g.
        //  .windowStyle(.plain) would produce a plain containing Area()
        WindowGroup {
            Areas()
        }
        // a widget
        .defaultSize(width: 1, height: 0.6, depth: 0.5, in: .meters)
    }
}






// Q & A: How to grab a object to be closer in Dev mode
