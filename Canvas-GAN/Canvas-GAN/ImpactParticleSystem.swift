//
//  ImpactParticleSystem.swift
//  Canvas-GAN
//
//  Created by Guo Siqi on 11/18/23.
//

import Foundation

import RealityKit

struct ProjectileComponent: Component, Codable {
    // If the particle has made impact with the canvas and has subsequently bursted
    public var bursted = false
    // manage the state to tell the component whether if it should or can burst
    public var canBurst = false
}


struct ImpactParticleSystem: System {
    static let projectileQuery = EntityQuery(where: .has(ProjectileComponent.self))
    static let particleQuery = EntityQuery(where: .has(ParticleEmitterComponent.self))
    init(scene: Scene) {}
    //
    // update called on every frame
    func update(context: SceneUpdateContext) {
        var iter = context.entities(matching: Self.projectileQuery, updatingSystemWhen: .rendering).makeIterator()
        guard let projectile = iter.next() else { return }
        guard var projectileComponent = projectile.components[ProjectileComponent.self] else { return }
        
        // if it is time for a burst
        if (projectileComponent.bursted == false && projectileComponent.canBurst == true) {
            // look for impact particles using the query
            for p in context.entities(matching: Self.particleQuery, updatingSystemWhen: .rendering) {
                if p.name == "ImpactParticle" {
                    p.components[ParticleEmitterComponent.self]?.burst()
                }
            }
            // The Particle bursted.
            // modify and reassign projectile component
            projectileComponent.bursted = true
            projectile.components[ProjectileComponent.self] = projectileComponent
        }
    }
}

/* projectile: ParticleRoot
 *     children[0]: ProjectileParticle
 *     children[1]: ProjectileTrail
 *              components: ParticleEmitterComponent
 *     components: ProjectileComponent
 *
 * impactParticle: ImpactParticle
 *     components: ParticleEmitterComponent
 */
