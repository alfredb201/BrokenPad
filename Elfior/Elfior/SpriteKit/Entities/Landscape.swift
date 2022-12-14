//
//  Landscape.swift
//  Elfior
//
//  Created by Pierpaolo Siciliano on 13/12/22.
//

import SpriteKit

class Landscape {
    var backgroundElements: [SKSpriteNode] = []
    var groundElements: [SKSpriteNode] = []
    var cloudElements: [SKSpriteNode] = []
    var treeElements: [SKSpriteNode] = []
    
    var village: SKSpriteNode!
    var firepit: SKSpriteNode!
    var sky: SKSpriteNode!
    var HUD: SKSpriteNode!
    
    var groundHeight: CGFloat = 0.0
    let numberOfClouds = Int.random(in: 7...12)
    var firstHill : SKSpriteNode!
    
    func createSky(scene: SceneModel) -> SKSpriteNode {
        let sky = SKSpriteNode(
            color: UIColor(red: 99/255, green: 167/255, blue: 241/255, alpha: 1),
            size: CGSize(width: scene.frame.width, height: scene.frame.height)
        )
        sky.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        sky.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
        sky.zPosition = -40
        
        return sky
    }
    
    func createVillage(scene: SceneModel) -> SKSpriteNode {
        village = SKSpriteNode(imageNamed: "Village")
        village.name = "village"
        village.position = CGPoint(x: scene.size.width / 2, y: groundHeight / 2)
        village.zPosition = -20
        backgroundElements.append(village)
        
        return village
    }
    
    func createGround() -> [SKSpriteNode] {
        for i in 0...1{
            let ground = SKSpriteNode(texture: SKTexture(imageNamed: "GameGround"))
            ground.name = "ground"
            ground.position = CGPoint(
                x: (ground.size.width / 2 + (ground.size.width * CGFloat(i))),
                y: ground.texture!.size().height / 2
            )
            ground.zPosition = 0
            
            ground.physicsBody = SKPhysicsBody(texture: ground.texture!, size: ground.texture!.size())
            ground.physicsBody?.categoryBitMask = PhysicsCategory.ground.rawValue
            ground.physicsBody?.isDynamic = false
            
            groundElements.append(ground)
            groundHeight = ground.size.height
        }
        return groundElements
    }
//
//    func createMovingGround(scene: SceneModel) -> SKSpriteNode {
//        let ground = SKSpriteNode(texture: SKTexture(imageNamed: "GameGround"))
//        ground.position = CGPoint(
//            x: 0,
//            y: 0
//        )
//        ground.setScale(1/3)
//        ground.zPosition = 0
//
//        ground.physicsBody = SKPhysicsBody(texture: ground.texture!, size: ground.texture!.size())
//        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground.rawValue
//        ground.physicsBody?.isDynamic = false
//
//        let moveLeft = SKAction.move(to: CGPoint(x: -ground.size.width, y: ground.position.y), duration: 10)
//        let moveReset = SKAction.removeFromParent()
//        let moveLoop = SKAction.sequence([moveLeft, moveReset])
//        ground.run(moveLoop)
//
//        return ground
//    }
    
//    func startGround() {
//        for groundElement in groundElements {
//            let moveLeft = SKAction.move(
//                to: CGPoint(x: -groundElement.size.width, y: groundElement.position.y),
//                duration: 10
//            )
//            let moveReset = SKAction.removeFromParent()
//            let moveLoop = SKAction.sequence([moveLeft, moveReset])
//            groundElement.run(moveLoop)
//        }
//    }
    
//    func stopGround() {
//        for groundElement in groundElements {
//            groundElement.removeAllActions()
//        }
//    }
    
    func createFirepit() -> SKSpriteNode {
        firepit = SKSpriteNode(texture: SKTexture(imageNamed: "Firepit"))
        firepit.setScale(3.0)
        firepit.position = CGPoint(x: elfior.position.x + 70, y: groundHeight / 2.5)
        firepit.zPosition = -15
        
        backgroundElements.append(firepit)
        
        return firepit
    }
    
    func createClouds(scene: SceneModel) -> [SKSpriteNode] {
        for _ in 0...numberOfClouds {
            cloudElements.append(createSingleCloud(scene: scene, firstClouds: true))
        }
        return cloudElements
    }
    
    func removeBackground() {
        for element in backgroundElements {
            element.removeFromParent()
        }
    }
    
    func createSingleCloud(scene: SceneModel, firstClouds: Bool) -> SKSpriteNode {
        let cloudTexture = SKTexture(imageNamed: "Cloud")
        let cloud = SKSpriteNode(texture: cloudTexture)
        cloud.yScale = CGFloat.random(in: 1.0...3.0)
        cloud.xScale = Int.random(in: 0...9) < 5 ? cloud.yScale : -cloud.yScale
        cloud.position = CGPoint(
            x: firstClouds ? scene.frame.width * (CGFloat.random(in: 0.0...3.0) / 3) : scene.frame.width + cloudTexture.size().width,
            y: scene.frame.height * CGFloat.random(in: 0.5...0.9)
        )
        cloud.zPosition = -40
        
        let moveLeft = SKAction.move(
            to: CGPoint(x: -cloud.size.width, y: cloud.position.y),
            duration: cloud.position.x / 10
        )
        let moveReset = SKAction.removeFromParent()
        let decreaseCloudCounter = SKAction.run {
            scene.actualNumberOfClouds -= 1
        }
        let moveLoop = SKAction.sequence([moveLeft, moveReset, decreaseCloudCounter])
        cloud.run(moveLoop)
        
        return cloud
    }
    
    func createTrees(scene: SceneModel) -> [SKSpriteNode] {
        for i in 1...10 {
            treeElements.append(createSingleTree(scene: scene, iterator: i, hasStarted: scene.hasStarted))
        }
        return treeElements
    }
    
    func createSingleTree(scene: SceneModel, iterator: Int?, hasStarted: Bool) -> SKSpriteNode {
        
        if (!hasStarted) {
            let tree = SKSpriteNode(texture: iterator! % 2 == 1 ? SKTexture(imageNamed: "Tree") : SKTexture(imageNamed: "Tree2"))
            tree.position = CGPoint(x: scene.frame.width * (0.1 * CGFloat(iterator!)), y: iterator! % 2 == 1 ? groundHeight / 2.1 : groundHeight / 2.8)
            tree.zPosition = -30
            
            backgroundElements.append(tree)
            return tree

        } else {
            let treePosition = Int.random(in: 0...1)
            let tree = SKSpriteNode(texture: treePosition % 2 == 1 ? SKTexture(imageNamed: "Tree") : SKTexture(imageNamed: "Tree2"))
            tree.position = CGPoint(x: scene.frame.width + 200, y: treePosition % 2 == 1 ? groundHeight / 2.1 : groundHeight / 2.8 )
            tree.zPosition = -30
            
            let moveLeft = SKAction.move(
                to: CGPoint(x: -tree.size.width, y: tree.position.y),
                duration: tree.position.x / 20
            )
            let moveReset = SKAction.removeFromParent()
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            tree.run(moveLoop)
            return tree

        }
    }
    
    func createHUD(scene: SceneModel) -> SKSpriteNode {
        HUD = SKSpriteNode(texture: SKTexture(imageNamed: "HUD3"))
        HUD.size = CGSize(width: HUD.size.width / 3, height: HUD.size.height / 3)
        HUD.position = CGPoint(x: HUD.size.width / 1.5, y: scene.frame.height)
        
        return HUD
    }
    
    func addHills(scene: SceneModel) -> SKSpriteNode {
        let hills = SKSpriteNode(imageNamed: "Hills")
        hills.position = CGPoint(x: 670, y: groundHeight / 2.5)
        hills.zPosition = -35
        hills.name = "hills"
        
       
        return hills
    }
    
    func moveFirstHill() {
        let moveAction = SKAction.move(
            to: CGPoint(x: -firstHill.size.width, y: groundHeight / 2.5),
            duration: TimeInterval(30)
        )
        let moveActionDone = SKAction.removeFromParent()
        firstHill.run(SKAction.sequence([moveAction, moveActionDone]))
    }
    
    
    func addHole(scene: SceneModel) -> SKSpriteNode {
        let hole = SKSpriteNode(texture: SKTexture(imageNamed: "Hole"))
        hole.position = CGPoint(x: scene.size.width + hole.size.width / 2, y: groundHeight / 2)
        hole.zPosition = 10
        
        hole.physicsBody = SKPhysicsBody(
            texture: hole.texture!,
            size: CGSize(width: hole.texture!.size().width, height: hole.texture!.size().height)
        )
        hole.physicsBody?.categoryBitMask = PhysicsCategory.nothing.rawValue
        hole.physicsBody?.contactTestBitMask = PhysicsCategory.nothing.rawValue
        hole.physicsBody?.collisionBitMask = PhysicsCategory.nothing.rawValue
        hole.physicsBody?.isDynamic = false
                
        let moveAction = SKAction.move(
            to: CGPoint(x: -hole.size.width/2, y: groundHeight / 2),
            duration: TimeInterval(10)
        )
        let moveActionDone = SKAction.removeFromParent()
        hole.run(SKAction.sequence([moveAction, moveActionDone]))
        
        return hole
    }
}
