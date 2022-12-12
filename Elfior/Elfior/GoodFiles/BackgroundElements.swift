//
//  BackgroundElements.swift
//  Elfior
//
//  Created by Mattia Ferrara on 12/12/22.
//

import Foundation
import SpriteKit

var backgroundElements: [SKSpriteNode] = []
var groundElements: [SKSpriteNode] = []
var cloudElements: [SKSpriteNode] = []
var treeElements: [SKSpriteNode] = []

var village: SKSpriteNode!
var firepit: SKSpriteNode!
var sky: SKSpriteNode!
var HUD: SKSpriteNode!


let groundTexture = SKTexture(imageNamed: "GameGround")
let treeTexture = SKTexture(imageNamed: "Tree")
let cloudTexture = SKTexture(imageNamed: "Cloud")
let cloudsTexture = SKTexture(imageNamed: "Clouds")

var groundHeight: CGFloat = 0.0
let numberOfClouds = Int(random(min: 7, max: 12))

func createSky(gameScene: GameScene) -> SKSpriteNode{
    let sky = SKSpriteNode(color: UIColor(ciColor: CIColor(red: 99/255, green: 167/255, blue: 241/255)), size: CGSize(width: gameScene.frame.width, height: gameScene.frame.height))
    sky.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    sky.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY)
    sky.zPosition = -40
    
    return sky
}


func createVillage(gameScene: GameScene) -> SKSpriteNode{
    village = SKSpriteNode(imageNamed: "Village")
    village.zPosition = -20
    village.anchorPoint = CGPoint.zero
    village.position = CGPoint(x: gameScene.size.width/20, y: groundHeight / 4.0)
    village.xScale = 0.9
    village.yScale = 0.9
    village.name = "village"
    backgroundElements.append(village)
    
    return village
}

func createGround() -> [SKSpriteNode]{
    for i in 0 ... 3 {
        let ground = SKSpriteNode(texture: groundTexture)
        ground.zPosition = 0
        ground.position = CGPoint(x: (ground.size.width / 2 + (ground.size.width * CGFloat(i))), y: groundTexture.size().height / 2)
        ground.physicsBody = SKPhysicsBody(texture: ground.texture!, size: ground.texture!.size())
        ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground
        ground.physicsBody?.isDynamic = false
        groundElements.append(ground)
        groundHeight = ground.size.height
    }
    return groundElements
}

func startGround() {
    for groundElement in groundElements {
        let moveLeft = SKAction.moveBy(x: -groundTexture.size().width, y: 0, duration: 5)
        let moveReset = SKAction.moveBy(x: groundTexture.size().width, y: 0, duration: 0)
        let moveLoop = SKAction.sequence([moveLeft, moveReset])
        let moveForever = SKAction.repeatForever(moveLoop)
        
        groundElement.run(moveForever)
    
    }
}
    
func createFirepit() -> SKSpriteNode{
    let firepitTexture = SKTexture(imageNamed: "Firepit")
    firepit = SKSpriteNode(texture: firepitTexture)
    firepit.zPosition = -15
    firepit.setScale(3.0)
    firepit.position = CGPoint(x: elfior.position.x + 70, y: groundHeight / 2.5)

    backgroundElements.append(firepit)
    
    return firepit
}

func createClouds(gameScene: GameScene) -> [SKSpriteNode]{
    
    for _ in 0...numberOfClouds {
        cloudElements.append(createSingleCloud(gameScene: gameScene,firstClouds: true))
    }
    return cloudElements
}

func createSingleCloud(gameScene: GameScene, firstClouds: Bool) -> SKSpriteNode{
    let cloud = SKSpriteNode(texture: random(min: 0, max: 10) < 6.0 ? cloudTexture : cloudsTexture)
    cloud.zPosition = -35
    cloud.yScale = random(min: 1.0, max: 3.0)
    cloud.xScale = random(min: 0, max: 100) < 50 ? cloud.yScale : -cloud.yScale
    cloud.position = CGPoint(x: firstClouds ? gameScene.frame.width * (random(min: 0, max: 3.0) / 3) : gameScene.frame.width + cloudTexture.size().width, y: gameScene.frame.height * random(min: 0.5, max: 0.9))

    let moveLeft = SKAction.move(to: CGPoint(x: -cloud.size.width, y: cloud.position.y), duration: cloud.position.x / 10)
    let moveReset = SKAction.removeFromParent()
    let decreaseCloudCounter = SKAction.run {
        gameScene.actualNumberOfClouds -= 1
    }
    let moveLoop = SKAction.sequence([moveLeft, moveReset, decreaseCloudCounter])
    cloud.run(moveLoop)
    
    return cloud
}

func createTrees(gameScene: GameScene) -> [SKSpriteNode]{
    for i in 1...10 {
        treeElements.append(createSingleTree(gameScene: gameScene, iterator: i, hasStarted: gameScene.hasStarted))
    }
    
    return treeElements
}

func createSingleTree(gameScene: GameScene, iterator: Int?, hasStarted: Bool) -> SKSpriteNode{
    let tree = SKSpriteNode(texture: treeTexture)
    if(!hasStarted){
        tree.setScale(3.0)
        tree.zPosition = -30
        tree.position = CGPoint(x: gameScene.frame.width * (0.1 * CGFloat(iterator!)), y: groundHeight / 2.5)
        backgroundElements.append(tree)
        
    }
    else{
        tree.setScale(random(min: 0.5, max: 4.0))
        tree.position = CGPoint(x: gameScene.frame.width + 200, y: groundHeight / 2.5)
        tree.zPosition = -30
        let moveLeft = SKAction.move(to: CGPoint(x: -tree.size.width, y: tree.position.y), duration: tree.position.x / 20)
        let moveReset = SKAction.removeFromParent()
        let moveLoop = SKAction.sequence([moveLeft, moveReset])
        tree.run(moveLoop)
    }
    return tree

}
func createHUD(gameScene: GameScene) -> SKSpriteNode{
    HUD = SKSpriteNode(texture: SKTexture(imageNamed: "HUD3"))
    HUD.size = CGSize(width: HUD.size.width / 2, height: HUD.size.height / 2)
    HUD.position = CGPoint(x: HUD.size.width / 1.5, y: gameScene.frame.height)
    
    return HUD
}


func addHills(gameScene: GameScene) -> SKSpriteNode{
    let hills = SKSpriteNode(imageNamed: "Hills")
    hills.position = CGPoint(x: gameScene.size.width + 200, y: groundHeight / 2.5)
    hills.zPosition = -35
    hills.setScale(random(min: 5.0, max: 8.0))
    
    let moveAction = SKAction.move(to: CGPoint(x: -hills.size.width/2, y: groundHeight / 2.5), duration: TimeInterval(hills.position.x / 20))
    let moveActionDone = SKAction.removeFromParent()
    
    hills.run(SKAction.sequence([moveAction, moveActionDone]))
    return hills

}
func addHole(gameScene: GameScene) -> SKSpriteNode{
    let holeTexture = SKTexture(imageNamed: "Hole")
    let hole = SKSpriteNode(texture: holeTexture)
    hole.position = CGPoint(x: gameScene.size.width + hole.size.width / 2, y: groundHeight / 2)
    hole.zPosition = 10
    
    hole.physicsBody = SKPhysicsBody(texture: holeTexture, size: CGSize(width: holeTexture.size().width, height: holeTexture.size().height))
    hole.physicsBody?.isDynamic = false
    hole.physicsBody?.categoryBitMask = PhysicsCategory.Hole
    hole.physicsBody?.contactTestBitMask = PhysicsCategory.Player
    hole.physicsBody?.collisionBitMask = PhysicsCategory.Nobody
    
    let randomDuration = random(min: CGFloat(3.0), max: CGFloat(6.0))

    let moveAction = SKAction.move(to: CGPoint(x: -hole.size.width/2, y: groundHeight / 2), duration: TimeInterval(randomDuration))
    let moveActionDone = SKAction.removeFromParent()
    hole.run(SKAction.sequence([moveAction, moveActionDone]))
    
    return hole
}
