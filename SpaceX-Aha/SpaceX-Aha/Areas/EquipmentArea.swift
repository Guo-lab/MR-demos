//
//  EquipmentArea.swift
//  SpaceX-Aha
//
//  Created by Guo Siqi on 11/20/23.
//

import SwiftUI

struct EquipmentArea: View {
    // Environment Options
    //      To open a window
    //      To dismiss a window
    //      To open an immersive space
    //      To close an immersive space
    @Environment(ViewModel.self) private var viewModel
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    
    var body: some View {
        // Any changes on this binding model would be reflected within the view
        @Bindable var model = viewModel
        
        HStack {
            // ============= Capsule ================
            VStack {
                Image("equipment-capsule")
                    .resizable()
                    .frame(width: 450, height: 450)
                    .padding(20)
                
                // Toggle(isOn: <#T##Binding<Bool>#>, label: <#T##() -> View#>)
                Toggle(
                    model.isShowingRocketCapsule ? "Hide Rocket Capsule(Volumetric)" : "Show Rocket Capsule(Volumetric)",
                    isOn: $model.isShowingRocketCapsule
                )
                // onChange(of: <#T##Equatable#>, <#T##action: (Equatable, Equatable) -> Void##(Equatable, Equatable) -> Void##(_ oldValue: Equatable, _ newValue: Equatable) -> Void#>)
                .onChange(of: model.isShowingRocketCapsule) { _, isShowing in
                    if isShowing { // openWindow Volumetric (windowGroup in MainApp)
                        openWindow(id: "CapsuleRealityArea")
                    } else { // dismissWindow Volumetric
                        dismissWindow(id: "CapsuleRealityArea")
                    }
                }
                .toggleStyle(.button)
                .padding(20)
            }
            .glassBackgroundEffect()
            .padding(30)
            
            
            // ============= Full Capsule =============
            VStack {
                Image("equipment-fullrocket")
                    .resizable()
                    .frame(width: 450, height: 450)
                    .padding(20)
                
                Toggle(
                    model.isShowingFullRocketCapsule ? "Hide Full Rocket Capsule(Full Immersive)" : "Show Full Rocket Capsule(Full Immersive)",
                    isOn: $model.isShowingFullRocketCapsule
                )
                .onChange(of: model.isShowingFullRocketCapsule) { _, isShowing in
                    Task {
                        if isShowing { // openImmersive (immersiveSpace in MainApp)
                            await openImmersiveSpace(id: "FullRocketRealityArea")
                        } else { // dismissImmersive
                            await dismissImmersiveSpace()
                        }
                    }
                }
                .toggleStyle(.button)
                .padding(20)
            }
            .glassBackgroundEffect()
            
        }
    }
}

#Preview {
    EquipmentArea()
        .environment(ViewModel())
}
