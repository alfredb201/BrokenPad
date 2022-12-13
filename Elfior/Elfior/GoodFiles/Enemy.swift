//
//  Enemy.swift
//  Elfior
//
//  Created by Mattia Ferrara on 12/12/22.
//

import Foundation
import SpriteKit

    
var ogre: SKSpriteNode!
var shieldedOgre: SKSpriteNode!
var armoredOgre: SKSpriteNode!

func addOgre(gameScene: GameScene, groundHeight: CGFloat) -> SKSpriteNode{
        ogre = SKSpriteNode(imageNamed: "Ogre")
    ogre.name = "ogre"
        ogre.position = CGPoint(x: gameScene.size.width + ogre.size.width / 2, y: groundHeight / 2.5)
        ogre.zPosition = 10
        ogre.size = CGSize(width: ogre.size.width / 1.5, height: ogre.size.height / 1.5)
        ogre.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: ogre.size.width / 2, height: ogre.size.height / 2))
        ogre.physicsBody?.isDynamic = false
    ogre.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
    ogre.physicsBody?.contactTestBitMask = PhysicsCategory.arrow.rawValue | PhysicsCategory.player.rawValue
    ogre.physicsBody?.collisionBitMask = PhysicsCategory.nothing.rawValue
        
        
    let randomDuration = random(min: CGFloat(5.0), max: CGFloat(7.0))

        let moveAction = SKAction.move(to: CGPoint(x: -ogre.size.width/2, y: groundHeight / 2.5), duration: TimeInterval(randomDuration))
        let moveActionDone = SKAction.removeFromParent()
    let moveAnimation = SKAction.run {
        ogreWalkAnimation(enemy: ogre)
    }
        ogre.run(SKAction.sequence([moveAnimation, moveAction, moveActionDone]))
        return ogre
    }

func addShieldedOgre(gameScene: GameScene, groundHeight: CGFloat) -> SKSpriteNode{
    shieldedOgre = SKSpriteNode(imageNamed: "ShieldedOgreWalk1")
    shieldedOgre.name = "shieldedOgre"
    shieldedOgre.position = CGPoint(x: gameScene.size.width + shieldedOgre.size.width / 2, y: groundHeight / 2.5)
    shieldedOgre.zPosition = 10
    shieldedOgre.setScale(0.3)
    shieldedOgre.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: shieldedOgre.size.width / 2, height: shieldedOgre.size.height / 2))
    shieldedOgre.physicsBody?.isDynamic = false
    shieldedOgre.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
    shieldedOgre.physicsBody?.contactTestBitMask = PhysicsCategory.arrow.rawValue | PhysicsCategory.player.rawValue
    shieldedOgre.physicsBody?.collisionBitMask = PhysicsCategory.nothing.rawValue
        
    let randomDuration = random(min: CGFloat(5.0), max: CGFloat(7.0))

        let moveAction = SKAction.move(to: CGPoint(x: -shieldedOgre.size.width/2, y: groundHeight / 2.5), duration: TimeInterval(randomDuration))
        let moveActionDone = SKAction.removeFromParent()
    
    let moveAnimation = SKAction.run {
        shieldedOgreWalkAnimation(enemy: shieldedOgre)
    }
    shieldedOgre.run(SKAction.sequence([moveAnimation,moveAction, moveActionDone]))
        return shieldedOgre
    }

func addArmoredOgre(gameScene: GameScene, groundHeight: CGFloat) -> SKSpriteNode{
    armoredOgre = SKSpriteNode(imageNamed: "ArmoredOgreWalk1")
    armoredOgre.name = "armoredOgre"
    armoredOgre.position = CGPoint(x: gameScene.size.width + armoredOgre.size.width / 2, y: groundHeight / 2.5)
    armoredOgre.zPosition = 10
    armoredOgre.setScale(0.3)
    armoredOgre.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: armoredOgre.size.width / 2, height: armoredOgre.size.height / 2))
    armoredOgre.physicsBody?.isDynamic = false
    armoredOgre.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
    armoredOgre.physicsBody?.contactTestBitMask = PhysicsCategory.arrow.rawValue | PhysicsCategory.player.rawValue
    armoredOgre.physicsBody?.collisionBitMask = PhysicsCategory.nothing.rawValue
    
        
    let randomDuration = random(min: CGFloat(5.0), max: CGFloat(7.0))

        let moveAction = SKAction.move(to: CGPoint(x: -armoredOgre.size.width/2, y: groundHeight / 2.5), duration: TimeInterval(randomDuration))
        let moveActionDone = SKAction.removeFromParent()
//    let moveAnimation = SKAction.run {
//        ogreWalkAnimation(enemy: armoredOgre)
//    }
    armoredOgre.run(SKAction.sequence([moveAction, moveActionDone]))
        return armoredOgre
    }

func enemyDeathAnimation(enemy: SKSpriteNode!) {
    var enemyAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "OgreDeath")
    }
    var enemyDeathTextures: [SKTexture] {
        return [
            enemyAtlas.textureNamed("OgreDeath1"),
            enemyAtlas.textureNamed("OgreDeath2"),
            enemyAtlas.textureNamed("OgreDeath3"),
            enemyAtlas.textureNamed("OgreDeath4"),
            enemyAtlas.textureNamed("OgreDeath5"),
            enemyAtlas.textureNamed("OgreDeath6"),
            enemyAtlas.textureNamed("OgreDeath7"),
            enemyAtlas.textureNamed("OgreDeath8"),
            enemyAtlas.textureNamed("OgreDeath9")
        ]
    }
    
    let deathAnimation = SKAction.animate(with: enemyDeathTextures, timePerFrame: 0.1)
    
    enemy.run(deathAnimation, withKey: "OgreDeathAnimation")
}

func ogreWalkAnimation(enemy: SKSpriteNode!) {
    var enemyAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "OgreWalk")
    }
    var enemyWalkTextures: [SKTexture] {
        return [
            enemyAtlas.textureNamed("OgreWalk1"),
            enemyAtlas.textureNamed("OgreWalk2"),
            enemyAtlas.textureNamed("OgreWalk3"),
            enemyAtlas.textureNamed("OgreWalk4"),
            enemyAtlas.textureNamed("OgreWalk5"),
            enemyAtlas.textureNamed("OgreWalk6"),
            enemyAtlas.textureNamed("OgreWalk7"),
            enemyAtlas.textureNamed("OgreWalk8")
        ]
    }
    
    let walkAnimation = SKAction.animate(with: enemyWalkTextures, timePerFrame: 0.1)
    
    enemy.run(SKAction.repeatForever(walkAnimation), withKey: "OgreWalkAnimation")
}

func shieldedOgreWalkAnimation(enemy: SKSpriteNode!) {
    var enemyAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "ShieldedOgreWalk")
    }
    var enemyWalkTextures: [SKTexture] {
        return [
            enemyAtlas.textureNamed("ShieldedOgreWalk1"),
            enemyAtlas.textureNamed("ShieldedOgreWalk2"),
            enemyAtlas.textureNamed("ShieldedOgreWalk3"),
            enemyAtlas.textureNamed("ShieldedOgreWalk4"),
            enemyAtlas.textureNamed("ShieldedOgreWalk5"),
            enemyAtlas.textureNamed("ShieldedOgreWalk6"),
            enemyAtlas.textureNamed("ShieldedOgreWalk7"),
            enemyAtlas.textureNamed("ShieldedOgreWalk8")
        ]
    }
    
    let walkAnimation = SKAction.animate(with: enemyWalkTextures, timePerFrame: 0.1)
    
    enemy.run(SKAction.repeatForever(walkAnimation), withKey: "OgreWalkAnimation")
}

    

