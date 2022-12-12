//
//  Enemy.swift
//  Elfior
//
//  Created by Mattia Ferrara on 12/12/22.
//

import Foundation
import SpriteKit

    
    var ogre: SKSpriteNode!
    
func addEnemy(gameScene: GameScene, groundHeight: CGFloat) -> SKSpriteNode{
        ogre = SKSpriteNode(imageNamed: "Ogre")
        ogre.position = CGPoint(x: gameScene.size.width + ogre.size.width / 2, y: groundHeight / 2.5)
        ogre.zPosition = 10
        
        ogre.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: ogre.size.width / 2, height: ogre.size.height / 2))
        ogre.physicsBody?.isDynamic = false
        ogre.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        ogre.physicsBody?.contactTestBitMask = PhysicsCategory.Arrow | PhysicsCategory.Player
        ogre.physicsBody?.collisionBitMask = PhysicsCategory.Nobody
        
        
        let randomDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))

        let moveAction = SKAction.move(to: CGPoint(x: -ogre.size.width/2, y: groundHeight / 2.5), duration: TimeInterval(randomDuration))
        let moveActionDone = SKAction.removeFromParent()
  
        ogre.run(SKAction.sequence([moveAction, moveActionDone]))
        return ogre
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
    

