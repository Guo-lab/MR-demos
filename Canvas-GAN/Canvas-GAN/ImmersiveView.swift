//
//  ImmersiveView.swift
//  Canvas-GAN
//
//  Created by Guo Siqi on 11/17/23.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    // A reference to the View Model
    @Environment(ViewModel.self) private var viewModel
    
    // Text for Character - HCI
    @State private var inputText = ""
    @State public var showTextField = false
    
    @State private var assistant: Entity? = nil
    @State private var waveAnimation: AnimationResource? = nil
    
    // Anchor the entity
    @State var characterEntity: Entity = {
        let headAnchor = AnchorEntity(.head) // at the user's head
        headAnchor.position = [0.70, -0.35, -1]
        
        let radians = -30 * Float.pi / 180
        ImmersiveView.rotateEntityAroundYAxis(entity: headAnchor, angle: radians)
        
        return headAnchor
    }()
    
    // Canvas Entity
    @State var planeEntity: Entity = {
        // Once the RealityView loads, find the first place to fit the criteria of the anchor entity
        let wallAnchor = AnchorEntity(.plane(.vertical, classification: .wall, minimumBounds: SIMD2<Float>(0.6, 0.6)))
        
        let planeMesh = MeshResource.generatePlane(width: 3.75, depth: 2.625, cornerRadius: 0.1)
        var material = SimpleMaterial(color: .blue, isMetallic: false)
            material = ImmersiveView.loadImageMaterial(imageUrl: "think_different")
        
        let planeEntity = ModelEntity(mesh: planeMesh, materials: [material])
        planeEntity.name = "canvas"
        
        wallAnchor.addChild(planeEntity)
        return wallAnchor
    }()
    
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        RealityView { content, attachments in
            /* An entity would be placed to the oprigin of the coordinate space when it was added to the RealityView content
             */
            do // Add the initial RealityKit content
            {
                let immersiveEntity = try await Entity(named: "Immersive", in: realityKitContentBundle)
                
                characterEntity.addChild(immersiveEntity)
                content.add(characterEntity)
                content.add(planeEntity)
                
                // retrieve the text from attachments and attach it to the content
                // here the entity would match the tag id
                guard let attachmentEntity = attachments.entity(for: "attachment") else {return}
                attachmentEntity.position = SIMD3<Float>(0, 0.62, 0)
                let radians = 30 * Float.pi / 180
                ImmersiveView.rotateEntityAroundYAxis(entity: attachmentEntity, angle: radians)
                characterEntity.addChild(attachmentEntity)
                
                // identify assistant + applying basic animation
                // import from Reality Composer Pro (.usda files)
                let characterAnimationSceneEntity = try await Entity(named: "CharacterAnimations", in: realityKitContentBundle)
                guard let waveModel = characterAnimationSceneEntity.findEntity(named: "wave_model") else { return }
                guard let assistant = characterEntity.findEntity(named: "assistant") else { return }
                
                guard let idleAnimationResource = assistant.availableAnimations.first else { return }
                guard let waveAnimationResource = waveModel.availableAnimations.first else { return }
                let waveAnimation = try AnimationResource.sequence(with: [waveAnimationResource, idleAnimationResource.repeat()])
                
                assistant.playAnimation(idleAnimationResource.repeat())
                Task {
                    self.assistant = assistant
                    self.waveAnimation = waveAnimation
                }
            }
            catch
            {
                print("Error in RealityView: \(error)")
            }
        } 
        update: { _, _ in } attachments: {
            Attachment(id: "attachment") {
                VStack {
                    Text(inputText)
                        .frame(maxWidth: 600, alignment: .leading)
                        .font(.extraLargeTitle2)
                        .fontWeight(.regular)
                        .padding(40)
                        .glassBackgroundEffect()
                }
                .opacity(showTextField ? 1 : 0)
            }
        }
        .gesture(SpatialTapGesture().targetedToAnyEntity().onEnded {
            _ in
            viewModel.flowState = .INTRO
        })
        .onChange(of: viewModel.flowState) { _, newValue in
            switch newValue {
            case .IDLE:
                break
            case .INTRO:
                Task {
                    if (showTextField == false) {
                        withAnimation(.easeInOut(duration: 0.3)) { showTextField.toggle() }
                    }
                    if let assistant = self.assistant, let waveAnimation = self.waveAnimation {
                        assistant.playAnimation(waveAnimation.repeat(count: 1))
                    }
                    let texts = [
                        "Hey! Lets put some paintings with the Vision Pro. Ready for this? ( ͡❛ ͜ʖ ͡❛)",
                        "Amazing! Draw something and watch it come alive.",
                    ]
                    await animatePromptText(text: texts[0])
                }
                break
            case .PROJECTILEFLYING:
                break
            case .UPDATEWALLART: 
                break
            }
        }
    }
    
    
    static func rotateEntityAroundYAxis(entity: Entity, angle: Float)
    {
        var currentTransform = entity.transform
        
        // Create a quaternion representing a rotation around the Y-axis
        let rotation = simd_quatf(angle: angle, axis: [0, 1, 0])
        
        // Combine the rotation with the current transform
        currentTransform.rotation = rotation * currentTransform.rotation
        
        entity.transform = currentTransform
    }
    
    static func loadImageMaterial(imageUrl: String) -> SimpleMaterial 
    {
        do
        {
            let texture = try TextureResource.load(named: imageUrl)
            var material = SimpleMaterial()
            let color = SimpleMaterial.BaseColor(texture: MaterialParameters.Texture(texture))
            material.color = color
            return material
        }
        catch
        {
            fatalError(String(describing: error))
        }
    }
    
    /* help function */
    func animatePromptText(text: String) async {
        inputText = ""
        let words = text.split(separator: " ")
        for word in words {
            inputText.append(word + " ")
            let milliseconds = (1 + UInt64.random(in: 0 ... 1)) * 100
            try? await Task.sleep(for: .milliseconds(milliseconds))
        }
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
