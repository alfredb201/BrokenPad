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
    elfior.position = CGPoint(x: scene.frame.width / 3 - 30, y: groundHeight / 4.3)
    elfior.zPosition = 10
    
    elfior.physicsBody = SKPhysicsBody(
        texture: elfior.texture!,
        size: CGSize(width: elfior.texture!.size().width, height: elfior.texture!.size().height)
    )
    elfior.physicsBody?.categoryBitMask = PhysicsCategory.player.rawValue
    elfior.physicsBody?.contactTestBitMask = PhysicsCategory.enemy.rawValue
    elfior.physicsBody?.collisionBitMask = PhysicsCategory.ground.rawValue
    elfior.physicsBody?.allowsRotation = false
    elfior.physicsBody?.isDynamic = false
    elfior.physicsBody?.restitution = 0.0
    
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
            playerAtlas.textureNamed("ElfiorIdle5")
        ]
    }
    let idleAnimation = SKAction.animate(with: playerIdleTextures, timePerFrame: 0.3)
    
    elfior.run(SKAction.repeatForever(idleAnimation), withKey: "ElfiorIdleAnimation")
}

func ElfiorRunningAnimation() {
    var playerAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "ElfiorRunning")
    }
    var playerRunningTextures: [SKTexture] {
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
    let runningAnimation = SKAction.animate(with: playerRunningTextures, timePerFrame: 0.1)
    
    elfior.run(SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.repeatForever(runningAnimation)]), withKey: "ElfiorIdleAnimation")
}

func ElfiorHitAnimation() {
    var playerAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "ElfiorHit")
    }
    var playerHitTextures: [SKTexture] {
        return [
            playerAtlas.textureNamed("ElfiorHit1"),
            playerAtlas.textureNamed("ElfiorHit2"),
            playerAtlas.textureNamed("ElfiorHit3"),
            playerAtlas.textureNamed("ElfiorHit4"),
            playerAtlas.textureNamed("ElfiorHit5"),
            playerAtlas.textureNamed("ElfiorHit6"),
            playerAtlas.textureNamed("ElfiorHit7")
        ]
    }
    let hitAnimation = SKAction.animate(with: playerHitTextures, timePerFrame: 0.1)
    
    elfior.run(hitAnimation, withKey: "ElfiorIdleAnimation")
}

func ElfiorDeathAnimation() {
    var playerAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "ElfiorDeath")
    }
    var playerDeathTextures: [SKTexture] {
        return [
            playerAtlas.textureNamed("ElfiorDeath1"),
            playerAtlas.textureNamed("ElfiorDeath2"),
            playerAtlas.textureNamed("ElfiorDeath3"),
            playerAtlas.textureNamed("ElfiorDeath4"),
            playerAtlas.textureNamed("ElfiorDeath5"),
            playerAtlas.textureNamed("ElfiorDeath6"),
            playerAtlas.textureNamed("ElfiorDeath7"),
            playerAtlas.textureNamed("ElfiorDeath8")
        ]
    }
    let deathAnimation = SKAction.animate(with: playerDeathTextures, timePerFrame: 0.3)
    
    elfior.run(deathAnimation, withKey: "ElfiorDeathAnimation")
}

func movePlayer(groundHeight: CGFloat) {
    elfior.run(SKAction.moveBy(x: -100, y: 0, duration: 3.0))
    elfior.physicsBody?.isDynamic = true
}
