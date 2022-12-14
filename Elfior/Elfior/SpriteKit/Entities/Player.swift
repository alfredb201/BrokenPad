//
//  Player.swift
//  Elfior
//
//  Created by Pierpaolo Siciliano on 13/12/22.
//

import SpriteKit

var elfior: SKSpriteNode!

func createPlayer(scene: SceneModel, groundHeight: CGFloat) -> SKSpriteNode {
    elfior = SKSpriteNode(texture: SKTexture(imageNamed: "ElfiorIdle1"))
    elfior.setScale(0.5)
    elfior.position = CGPoint(x: scene.frame.width / 3 - 30, y: groundHeight / 3.5)
    elfior.zPosition = 10
    
    elfior.physicsBody = SKPhysicsBody(
        texture: elfior.texture!,
        size: CGSize(width: elfior.texture!.size().width / 2, height: elfior.texture!.size().height / 2)
    )
    elfior.physicsBody?.categoryBitMask = PhysicsCategory.player.rawValue
    elfior.physicsBody?.contactTestBitMask = PhysicsCategory.enemy.rawValue
    elfior.physicsBody?.collisionBitMask = PhysicsCategory.ground.rawValue
    elfior.physicsBody?.allowsRotation = false
    elfior.physicsBody?.isDynamic = false
    
    return elfior
}

func ElfiorAttackAnimation() {
    var playerAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "ElfiorAttack")
    }
    var playerIdleTextures: [SKTexture] {
        return [
            playerAtlas.textureNamed("ElfiorAttack1"),
            playerAtlas.textureNamed("ElfiorAttack2"),
            playerAtlas.textureNamed("ElfiorAttack3"),
            playerAtlas.textureNamed("ElfiorAttack4"),
            playerAtlas.textureNamed("ElfiorAttack5"),
            playerAtlas.textureNamed("ElfiorAttack6"),
            playerAtlas.textureNamed("ElfiorAttack7"),
            playerAtlas.textureNamed("ElfiorAttack8"),
        ]
    }
    let attackAnimation = SKAction.animate(with: playerIdleTextures, timePerFrame: 0.1)
    
    elfior.run(attackAnimation, withKey: "ElfiorAttackAnimation")
}

func ElfiorIdleAnimation() {
    var playerAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "ElfiorIdle")
    }
    var playerIdleTextures: [SKTexture] {
        return [
            playerAtlas.textureNamed("ElfiorIdle1"),
            playerAtlas.textureNamed("ElfiorIdle2"),
            playerAtlas.textureNamed("ElfiorIdle3"),
            playerAtlas.textureNamed("ElfiorIdle4"),
            playerAtlas.textureNamed("ElfiorIdle5"),
            playerAtlas.textureNamed("ElfiorIdle6"),
            playerAtlas.textureNamed("ElfiorIdle7"),
            playerAtlas.textureNamed("ElfiorIdle8")
        ]
    }
    let idleAnimation = SKAction.animate(with: playerIdleTextures, timePerFrame: 0.3)
    
    elfior.run(SKAction.repeatForever(idleAnimation), withKey: "ElfiorIdleAnimation")
}

func ElfiorRunningAnimation() {
    var playerAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "ElfiorRunning")
    }
    var playerIdleTextures: [SKTexture] {
        return [
            playerAtlas.textureNamed("ElfiorRunning1"),
            playerAtlas.textureNamed("ElfiorRunning2"),
            playerAtlas.textureNamed("ElfiorRunning3"),
            playerAtlas.textureNamed("ElfiorRunning4"),
            playerAtlas.textureNamed("ElfiorRunning5"),
            playerAtlas.textureNamed("ElfiorRunning6"),
            playerAtlas.textureNamed("ElfiorRunning7"),
            playerAtlas.textureNamed("ElfiorRunning8")
        ]
    }
    let runningAnimation = SKAction.animate(with: playerIdleTextures, timePerFrame: 0.1)
    
    elfior.run(SKAction.repeatForever(runningAnimation), withKey: "ElfiorIdleAnimation")
}

func movePlayer(groundHeight: CGFloat) {
    elfior.run(SKAction.move(to: CGPoint(x: 150, y: groundHeight / 2.7), duration: 3.0))
    elfior.physicsBody?.isDynamic = true
}
