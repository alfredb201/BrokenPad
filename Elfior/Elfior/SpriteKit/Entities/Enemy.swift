//
//  Enemy.swift
//  Elfior
//
//  Created by Pierpaolo Siciliano on 13/12/22.
//

import SpriteKit






var ogre: SKSpriteNode!
var shieldedOgre: SKSpriteNode!
var armoredOgre: SKSpriteNode!

func addOgre(scene: SceneModel, groundHeight: CGFloat) -> SKSpriteNode {
    ogre = SKSpriteNode(imageNamed: "OgreWalk1")
    ogre.name = "ogre"
    
    ogre.position = CGPoint(x: scene.size.width + ogre.size.width / 2, y: groundHeight / 3.5)
    ogre.zPosition = 10
    
    ogre.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: ogre.size.width / 3, height: ogre.size.height / 1.5))
    ogre.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
    ogre.physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue
    ogre.physicsBody?.collisionBitMask = PhysicsCategory.nothing.rawValue
    ogre.physicsBody?.isDynamic = false
    
    let moveAction = SKAction.move(
        to: CGPoint(x: -ogre.size.width/2, y: groundHeight / 3.5),
        duration: TimeInterval(CGFloat.random(in: 3.0...5.0))
    )
    let moveActionDone = SKAction.removeFromParent()
    let moveAnimation = SKAction.run {
        ogreWalkAnimation(enemy: ogre)
    }
    ogre.run(SKAction.sequence([moveAnimation, moveAction, moveActionDone]))
    
    return ogre
}

func addShieldedOgre(scene: SceneModel, groundHeight: CGFloat) -> (SKSpriteNode, SKShapeNode) {
    shieldedOgre = SKSpriteNode(imageNamed: "ShieldedOgreWalk1")
    shieldedOgre.name = "shieldedOgre"
    shieldedOgre.setScale(0.3)
    shieldedOgre.position = CGPoint(x: scene.size.width + shieldedOgre.size.width / 2, y: groundHeight / 3.5)
    shieldedOgre.zPosition = 10
    
    shieldedOgre.physicsBody = SKPhysicsBody(rectangleOf: CGSize(
        width: shieldedOgre.size.width / 3,
        height: shieldedOgre.size.height / 1.5)
    )
    shieldedOgre.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
    shieldedOgre.physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue
    shieldedOgre.physicsBody?.collisionBitMask = PhysicsCategory.arrow.rawValue
    shieldedOgre.physicsBody?.isDynamic = false
    
    let ogreScoreHitArea = SKShapeNode(rectOf: CGSize(width: 10, height: 10))
    ogreScoreHitArea.position = CGPoint(x: shieldedOgre.position.x, y: shieldedOgre.position.y + 150)
    ogreScoreHitArea.name = "shieldedOgreScore"
    ogreScoreHitArea.fillColor = UIColor.clear
    ogreScoreHitArea.strokeColor = UIColor.clear
    ogreScoreHitArea.zPosition = 10
    
    ogreScoreHitArea.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: 300)
    )
    ogreScoreHitArea.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
    ogreScoreHitArea.physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue
    ogreScoreHitArea.physicsBody?.collisionBitMask = PhysicsCategory.nothing.rawValue
    ogreScoreHitArea.physicsBody?.isDynamic = false
    
    let moveAction = SKAction.moveTo(x: -shieldedOgre.size.width / 2, duration: TimeInterval(CGFloat.random(in: 3.0...5.0)))
    let moveActionDone = SKAction.removeFromParent()
    let moveAnimation = SKAction.run {
        shieldedOgreWalkAnimation(enemy: shieldedOgre)
    }
    shieldedOgre.run(SKAction.sequence([moveAnimation, moveAction, moveActionDone]))
    ogreScoreHitArea.run(SKAction.sequence([moveAction, moveActionDone]))
    
    return (shieldedOgre, ogreScoreHitArea)
}

func addArmoredOgre(scene: SceneModel, groundHeight: CGFloat) -> SKSpriteNode {
    var armoredOgre: SKSpriteNode
    let armoredOgreTexture = SKTexture(imageNamed: "ArmoredOgreWalk1")
    armoredOgre = SKSpriteNode(texture: armoredOgreTexture)
    armoredOgre.name = "armoredOgre"
    armoredOgre.setScale(0.3)
    armoredOgre.position = CGPoint(x: scene.size.width + armoredOgre.size.width / 2, y: groundHeight / 3.5)
    armoredOgre.zPosition = 10

    armoredOgre.physicsBody = SKPhysicsBody(rectangleOf: CGSize(
        width: armoredOgre.size.width / 3,
        height: armoredOgre.size.height / 1.5)
    )
    armoredOgre.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
    armoredOgre.physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue
    armoredOgre.physicsBody?.collisionBitMask = PhysicsCategory.nothing.rawValue
    armoredOgre.physicsBody?.isDynamic = false
    
    let moveAction = SKAction.move(
        to: CGPoint(x: -armoredOgre.size.width/2, y: groundHeight / 3.5),
        duration: TimeInterval(CGFloat.random(in: 5.0...7.0))
    )
    let moveActionDone = SKAction.removeFromParent()
  let moveAnimation = SKAction.run {
      armoredOgreWalkAnimation(enemy: armoredOgre)
  }
    armoredOgre.run(SKAction.sequence([moveAnimation, moveAction,moveActionDone]))
    
    return armoredOgre
}

func enemyDeathAnimation(enemy: SKSpriteNode!) {
    let atlas = SKTextureAtlas(named: "OgreDeath")
    let ogreDeathAnimation = SKAction.animate(
        with: [
            atlas.textureNamed("OgreDeath1"),
            atlas.textureNamed("OgreDeath2"),
            atlas.textureNamed("OgreDeath3"),
            atlas.textureNamed("OgreDeath4"),
            atlas.textureNamed("OgreDeath5"),
            atlas.textureNamed("OgreDeath6"),
            atlas.textureNamed("OgreDeath7"),
            atlas.textureNamed("OgreDeath8"),
            atlas.textureNamed("OgreDeath9")
        ],
        timePerFrame: 0.1)
    
    enemy.run(ogreDeathAnimation, withKey: "OgreDeathAnimation")
}

func ogreWalkAnimation(enemy: SKSpriteNode!) {
    let atlas = SKTextureAtlas(named: "BasicWalk")
    let ogreWalkAnimation = SKAction.animate(
        with: [
            atlas.textureNamed("OgreWalk1"),
            atlas.textureNamed("OgreWalk2"),
            atlas.textureNamed("OgreWalk3"),
            atlas.textureNamed("OgreWalk4"),
            atlas.textureNamed("OgreWalk5"),
            atlas.textureNamed("OgreWalk6"),
            atlas.textureNamed("OgreWalk7"),
            atlas.textureNamed("OgreWalk8")
        ],
        timePerFrame: 0.1)
    
    enemy.run(SKAction.repeatForever(ogreWalkAnimation), withKey: "OgreWalkAnimation")
}

func ogreAttackAnimation(enemy: SKSpriteNode!) {
    let atlas = SKTextureAtlas(named: "BasicAttack")
    let ogreAttackAnimation = SKAction.animate(
        with: [
            atlas.textureNamed("OgreAttack1"),
            atlas.textureNamed("OgreAttack2"),
            atlas.textureNamed("OgreAttack3"),
            atlas.textureNamed("OgreAttack4"),
            atlas.textureNamed("OgreAttack5")
        ],
        timePerFrame: 0.1)
    
    enemy.run(SKAction.repeatForever(ogreAttackAnimation), withKey: "OgreAttackAnimation")
}

func shieldedOgreWalkAnimation(enemy: SKSpriteNode!) {
    let atlas = SKTextureAtlas(named: "ShieldedWalk")
    let shieldedWalkAnimation = SKAction.animate(
        with: [
            atlas.textureNamed("ShieldedOgreWalk1"),
            atlas.textureNamed("ShieldedOgreWalk2"),
            atlas.textureNamed("ShieldedOgreWalk3"),
            atlas.textureNamed("ShieldedOgreWalk4"),
            atlas.textureNamed("ShieldedOgreWalk5"),
            atlas.textureNamed("ShieldedOgreWalk6"),
            atlas.textureNamed("ShieldedOgreWalk7"),
            atlas.textureNamed("ShieldedOgreWalk8")
        ],
        timePerFrame: 0.1)
    
    enemy.run(SKAction.repeatForever(shieldedWalkAnimation), withKey: "ShieldedOgreWalkAnimation")
}

func armoredOgreWalkAnimation(enemy: SKSpriteNode!) {
    let atlas = SKTextureAtlas(named: "ArmoredWalk")
    let shieldedWalkAnimation = SKAction.animate(
        with: [
            atlas.textureNamed("ArmoredOgreWalk1"),
            atlas.textureNamed("ArmoredOgreWalk2"),
            atlas.textureNamed("ArmoredOgreWalk3"),
            atlas.textureNamed("ArmoredOgreWalk4"),
            atlas.textureNamed("ArmoredOgreWalk5"),
            atlas.textureNamed("ArmoredOgreWalk6"),
            atlas.textureNamed("ArmoredOgreWalk7"),
            atlas.textureNamed("ArmoredOgreWalk8")
        ],
        timePerFrame: 0.1)
    
    enemy.run(SKAction.repeatForever(shieldedWalkAnimation), withKey: "ArmoredOgreWalkAnimation")
}
