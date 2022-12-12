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
        ogre.position = CGPoint(x: gameScene.size.width + ogre.size.width / 2, y: groundHeight / 2.5)
        ogre.zPosition = 10
        
        ogre.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: ogre.size.width / 2, height: ogre.size.height / 2))
        ogre.physicsBody?.isDynamic = false
    ogre.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
    ogre.physicsBody?.contactTestBitMask = PhysicsCategory.arrow.rawValue | PhysicsCategory.player.rawValue
    ogre.physicsBody?.collisionBitMask = PhysicsCategory.nothing.rawValue
        
        
        let randomDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))

        let moveAction = SKAction.move(to: CGPoint(x: -ogre.size.width/2, y: groundHeight / 2.5), duration: TimeInterval(randomDuration))
        let moveActionDone = SKAction.removeFromParent()
  
        ogre.run(SKAction.sequence([moveAction, moveActionDone]))
        return ogre
    }

func addShieldedOgre(gameScene: GameScene, groundHeight: CGFloat) -> SKSpriteNode{
    shieldedOgre = SKSpriteNode(imageNamed: "ShieldedOgreWalk1")
    shieldedOgre.position = CGPoint(x: gameScene.size.width + shieldedOgre.size.width / 2, y: groundHeight / 2.5)
    shieldedOgre.zPosition = 10
    shieldedOgre.setScale(0.5)
    shieldedOgre.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: shieldedOgre.size.width / 2, height: shieldedOgre.size.height / 2))
    shieldedOgre.physicsBody?.isDynamic = false
    shieldedOgre.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
    shieldedOgre.physicsBody?.contactTestBitMask = PhysicsCategory.arrow.rawValue | PhysicsCategory.player.rawValue
    shieldedOgre.physicsBody?.collisionBitMask = PhysicsCategory.nothing.rawValue
        
        
        let randomDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))

        let moveAction = SKAction.move(to: CGPoint(x: -shieldedOgre.size.width/2, y: groundHeight / 2.5), duration: TimeInterval(randomDuration))
        let moveActionDone = SKAction.removeFromParent()
  
    shieldedOgre.run(SKAction.sequence([moveAction, moveActionDone]))
        return shieldedOgre
    }

func addArmoredOgre(gameScene: GameScene, groundHeight: CGFloat) -> SKSpriteNode{
    armoredOgre = SKSpriteNode(imageNamed: "ArmoredOgreWalk1")
    armoredOgre.position = CGPoint(x: gameScene.size.width + armoredOgre.size.width / 2, y: groundHeight / 2.5)
    armoredOgre.zPosition = 10
    armoredOgre.setScale(0.5)
    armoredOgre.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: armoredOgre.size.width / 2, height: armoredOgre.size.height / 2))
    armoredOgre.physicsBody?.isDynamic = false
    armoredOgre.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
    armoredOgre.physicsBody?.contactTestBitMask = PhysicsCategory.arrow.rawValue | PhysicsCategory.player.rawValue
    armoredOgre.physicsBody?.collisionBitMask = PhysicsCategory.nothing.rawValue
        
        
        let randomDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))

        let moveAction = SKAction.move(to: CGPoint(x: -armoredOgre.size.width/2, y: groundHeight / 2.5), duration: TimeInterval(randomDuration))
        let moveActionDone = SKAction.removeFromParent()
  
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
    

