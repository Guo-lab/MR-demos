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
    
    // Notes: Declaring the ViewModel here and including it in the env is so important!
    // To solve BUGS in EquipmentView:
    //      SwiftUI/Environment+Objects.swift:32: Fatal error: No Observable object of type ViewModel found. A View.environmentObject(_:) for ViewModel may be missing as an ancestor of this view.
    @State private var model = ViewModel()
    
    var body: some Scene {
        // Apply different styles, positioning, and UINTS
        // e.g.
        //  .windowStyle(.plain) would produce a plain containing Area()
        WindowGroup {
            Areas()
                .environment(model)
        }
        // a widget
        .defaultSize(width: 1, height: 0.6, depth: 0.5, in: .meters)
        
        // ============ RealityViews ===========
        // ============== Capsule ==============
        WindowGroup(id: "CapsuleRealityArea") {
            CapsuleRealityArea()
                .environment(model)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 0.6, height: 0.6, depth: 0.6, in: .meters)
        
        // ============ Full Capsule ===========
        ImmersiveSpace(id: "FullRocketRealityArea") {
            FullRocketRealityArea()
                .environment(model)
        }
        .immersionStyle(selection: .constant(.full), in: .full)
    }
}






// Q & A: How to grab a object to be closer in Dev mode
