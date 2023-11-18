//
//  ImmersiveView.swift
//  Canvas-GAN
//
//  Created by Guo Siqi on 11/17/23.
//

import SwiftUI
import RealityKit
import RealityKitContent

// Listen to the action
import Combine


struct ImmersiveView: View {
    // A reference to the View Model
    @Environment(ViewModel.self) private var viewModel
    // For openWindow doodle_canvas
    @Environment(\.openWindow) private var openWindow
    
    // Text for Character - HCI
    @State private var inputText = ""
    @State public var showTextField = false
    
    @State private var assistant: Entity? = nil
    @State private var waveAnimation: AnimationResource? = nil
    @State private var jumpAnimation: AnimationResource? = nil
    
    @State private var projectile: Entity? = nil
    
    // Showing ot hiding the buttons
    @State public var showAttachmentButton = false
    //
    // Passing along whether the user press the button
    let tapSubject = PassthroughSubject<Void, Never>()
    @State var cancellable: AnyCancellable?
    
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
                
                // Particle Effects
                let projectileSceneEntity = try await Entity(named: "MainParticle", in: realityKitContentBundle)
                guard let projectile = projectileSceneEntity.findEntity(named: "ParticleRoot") else { return }
                projectile.children[0].components[ParticleEmitterComponent.self]?.isEmitting = false
                projectile.children[1].components[ParticleEmitterComponent.self]?.isEmitting = false
                projectile.components.set(ProjectileComponent())
                characterEntity.addChild(projectile)
                
                // Particle Impact
                let impactParticleSceneEntity = try await Entity(named: "ImpactParticle", in: realityKitContentBundle)
                guard let impactParticle = impactParticleSceneEntity.findEntity(named: "ImpactParticle") else { return }
                impactParticle.position = [0, 0, 0]
                impactParticle.components[ParticleEmitterComponent.self]?.burstCount = 500
                impactParticle.components[ParticleEmitterComponent.self]?.emitterShapeSize.x = 3.75 / 2.0
                impactParticle.components[ParticleEmitterComponent.self]?.emitterShapeSize.z = 2.625 / 2.0
                planeEntity.addChild(impactParticle)
                
                characterEntity.addChild(immersiveEntity)
                content.add(characterEntity)
                content.add(planeEntity)
                
                // retrieve the text from attachments and attach it to the content
                // here the entity would match the tag id
                guard let attachmentEntity = attachments.entity(for: "attachment") else { return }
                attachmentEntity.position = SIMD3<Float>(0, 0.62, 0)
                let radians = 30 * Float.pi / 180
                ImmersiveView.rotateEntityAroundYAxis(entity: attachmentEntity, angle: radians)
                characterEntity.addChild(attachmentEntity)
                
                // identify assistant + applying basic animation
                // import from Reality Composer Pro (.usda files)
                let characterAnimationSceneEntity = try await Entity(named: "CharacterAnimations", in: realityKitContentBundle)
                guard let waveModel = characterAnimationSceneEntity.findEntity(named: "wave_model") else { return }
                guard let jumpUpModel = characterAnimationSceneEntity.findEntity(named: "jump_up_model") else { return }
                guard let jumpFloatModel = characterAnimationSceneEntity.findEntity(named: "jump_float_model") else { return }
                guard let jumpDownModel = characterAnimationSceneEntity.findEntity(named: "jump_down_model") else { return }
                guard let assistant = characterEntity.findEntity(named: "assistant") else { return }
                
                guard let idleAnimationResource = assistant.availableAnimations.first else { return }
                guard let waveAnimationResource = waveModel.availableAnimations.first else { return }
                let waveAnimation = try AnimationResource.sequence(with: [waveAnimationResource, idleAnimationResource.repeat()])
                
                assistant.playAnimation(idleAnimationResource.repeat())
                
                guard let jumpUpAnimationResource = jumpUpModel.availableAnimations.first else { return }
                guard let jumpFloatAnimationResource = jumpFloatModel.availableAnimations.first else { return }
                guard let jumpDownAnimationResource = jumpDownModel.availableAnimations.first else { return }
                let jumpAnimation = try AnimationResource.sequence(with: [jumpUpAnimationResource, jumpFloatAnimationResource, jumpDownAnimationResource, idleAnimationResource.repeat()])
                
                Task {
                    self.assistant = assistant
                    self.waveAnimation = waveAnimation
                    self.jumpAnimation = jumpAnimation
                    self.projectile = projectile
                }
            }
            catch
            {
                print("Error in RealityView: \(error)")
            }
        }
        
        
        update: { _, _ in } attachments: {
            Attachment(id: "attachment") { // Tap Prompt Text
                VStack {
                    Text(inputText)
                        .frame(maxWidth: 600, alignment: .leading)
                        .font(.extraLargeTitle2)
                        .fontWeight(.regular)
                        .padding(40)
                        .glassBackgroundEffect()
                    if (showAttachmentButton == true) {
                        // HStack contains two buttons
                        HStack(spacing: 20) {
                            Button(action: { tapSubject.send() }) { Text("Yes, let's go!").font(.largeTitle).fontWeight(.regular).padding().cornerRadius(8) }.padding().buttonStyle(.bordered)
                            Button(action: {}) { Text("No").font(.largeTitle).fontWeight(.regular).padding().cornerRadius(8) }.padding().buttonStyle(.bordered)
                        }
                    }
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
                /* WARNING: onChange(of: Bool) action tried to update multiple times per frame.
                 * Could be fixed, as long as make the following task a async func
                 */
                Task {
                    if (showTextField == false) {
                        withAnimation(.easeInOut(duration: 0.3)) { showTextField.toggle() }
                    }
                    if let assistant = self.assistant, let waveAnimation = self.waveAnimation {
                        assistant.playAnimation(waveAnimation.repeat(count: 1))
                    }
                    
                    let texts = [
                        "Hey! Lets create some paintings with the Vision Pro. Ready for this? ( ͡❛ ͜ʖ ͡❛)", // @https://fsymbols.com/emoticons/
                        "Amazing! Draw something and watch it come alive. ( ͠❛ ͜ʖ ͡❛)",
                    ]
                    
                    await animatePromptText(text: texts[0])
                    
                    // After displaying all the builtin prompt, show button
                    withAnimation(.easeInOut(duration: 0.3)) { showAttachmentButton = true }
                    await waitForButtonTap(using: tapSubject)
                    withAnimation(.easeInOut(duration: 0.3)) { showAttachmentButton = false }
                    
                    Task {
                        await animatePromptText(text: texts[1])
                    }
                    
                    // Open a window with ID doodle_canvas after the user press the yes button
                    DispatchQueue.main.async {
                        openWindow(id: "doodle_canvas")
                    }
                    
                }
                break
                
            case .PROJECTILEFLYING:
                if let projectile = self.projectile {
                    /* The real tranform of the anchor entity could not be retrieved, so the particle is going to traverse towards the center of the simulator screen
                     */
                    let destination = Transform(scale: projectile.transform.scale, rotation: projectile.transform.rotation, translation: [-0.7, 0.15, -0.5] * 2)
                    Task {
                        let duration = 3.0
                        projectile.position = [0, 0.1, 0]
                        projectile.children[0].components[ParticleEmitterComponent.self]?.isEmitting = true
                        projectile.children[1].components[ParticleEmitterComponent.self]?.isEmitting = true
                        projectile.move(to: destination, relativeTo: self.characterEntity, duration: duration, timingFunction: .easeInOut)
                        
                        try? await Task.sleep(for: .seconds(duration))
                        projectile.children[0].components[ParticleEmitterComponent.self]?.isEmitting = false
                        projectile.children[1].components[ParticleEmitterComponent.self]?.isEmitting = false
                        viewModel.flowState = .UPDATEWALLART
                    }
                }
                break
                
            case .UPDATEWALLART:
                self.projectile?.components[ProjectileComponent.self]?.canBurst = true
                
                if let plane = planeEntity.findEntity(named: "canvas") as? ModelEntity {
                    plane.model?.materials = [ImmersiveView.loadImageMaterial(imageUrl: "sketch")]
                }
                if let assistant = self.assistant, let jumpAnimation = self.jumpAnimation {
                    Task {
                        try? await Task.sleep(for: .milliseconds(500))
                        assistant.playAnimation(jumpAnimation)
                        await animatePromptText(text: "Awesome! ᕙ(^▿^-ᕙ)")
                        try? await Task.sleep(for: .milliseconds(500))
                        await animatePromptText(text: "What else do you want to see in Vision Pro? ( ͡❛ ‿‿ ͡❛)")
                    }
                }
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
    
    /* ************* help function ************ */
    func animatePromptText(text: String) async {
        inputText = ""
        let words = text.split(separator: " ")
        for word in words {
            inputText.append(word + " ")
            let milliseconds = (1 + UInt64.random(in: 0 ... 1)) * 100
            try? await Task.sleep(for: .milliseconds(milliseconds))
        }
    }
    
    // Combine Framework
    /* When the button triggers the action, PassthroughSubject would send signal.
     * This function would listen to this event.
     * TabSubject would send a msg.
     * After that, sink receives a callback on the TapSubject and calls resume()
     */
    func waitForButtonTap(using buttonTapPublisher: PassthroughSubject<Void, Never>) async {
        await withCheckedContinuation { continuation in
            let cancellable = tapSubject.first().sink(receiveValue: { _ in continuation.resume() })
            self.cancellable = cancellable
        }
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
