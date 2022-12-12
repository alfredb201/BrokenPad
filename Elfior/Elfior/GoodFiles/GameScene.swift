//
//  GameScene.swift
//  Elfior
//
//  Created by Mattia Ferrara on 09/12/22.
//

import SpriteKit

struct PhysicsCategory {
    static let Nobody :UInt32 = 0
    static let All :UInt32 = UInt32.max
    static let Ground :UInt32 = 0b1
    static let Enemy :UInt32 = 0b10
    static let Hole :UInt32 = 0b100
    static let Arrow :UInt32 = 0b1000
    static let Player :UInt32 = 0b10000
}

enum GameState {
    case showingLogo
    case playing
    case dead
}

func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / Float(0xFFFFFFFF))
}

func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var actualNumberOfClouds = numberOfClouds {
        didSet{
            if actualNumberOfClouds == 0{
                actualNumberOfClouds = numberOfClouds
            }
            let cloudSpawn = SKAction.run {
                self.addChild(createSingleCloud(gameScene: self, firstClouds: false))
            }
            run(cloudSpawn)
        }
    }
    var startLabel: SKLabelNode!
    var gameState = GameState.showingLogo
    var playerLives: Int = 3 {
        didSet{
            if(playerLives > 0){
                HUD.texture = SKTexture(imageNamed: "HUD\(playerLives)")
            }
        }
    }
    var isInvuln: Bool = false
    var invulnTime: TimeInterval = 0
    var hasStarted: Bool = false
    
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVectorMake(0.0, -9.8)
        physicsWorld.contactDelegate = self
        setStartLabel()
        createBackground()

        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        upSwipe.direction = .up
        view.addGestureRecognizer(upSwipe)
    }

    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            switch sender.direction {
            case .up:
                // Call your jump function here
                if elfior.action(forKey: "jump") == nil { // check that there's no jump action running
                    //                    let jumpUp = SKAction.moveBy(x: 10, y: 50, duration: 1)
                    //                    let fallBack = SKAction.moveBy(x: -10, y: -50, duration: 1)
                    //
                    //                    player.run(SKAction.sequence([jumpUp, fallBack]), withKey:"jump")
                    elfior.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
                }
            default:
                break
            }
        }
    }
    
    func createBackground(){
        for ground in createGround() {
            addChild(ground)
        }
        addChild(createSky(gameScene: self))
        addChild(createVillage(gameScene: self))
        addChild(createPlayer(gameScene: self, groundHeight: groundHeight))
        addChild(createFirepit())
        
        for cloud in createClouds(gameScene: self) {
            addChild(cloud)
        }
        for tree in createTrees(gameScene: self) {
            addChild(tree)
        }
    }

    
    func setStartLabel(){
        startLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        startLabel.text = "Tap to begin"
        startLabel.fontSize = 40
        startLabel.position = CGPoint(x: frame.midX, y: frame.midY + 30)
        startLabel.fontColor = UIColor.black
        addChild(startLabel)
    }
    
    func startGame() {
        hasStarted = true
        movePlayer(groundHeight: groundHeight)
        startGround()
        
        for node in backgroundElements {
            let time = node.position.x / 100
            let isVillage = node.name == "village"
            let moveAction = SKAction.move(to: CGPoint(x: -node.frame.width, y: node.position.y), duration: isVillage ? 7 : time )
            node.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
        }
        addChild(createHUD(gameScene: self))
        let enemyCreate = SKAction.run {
            self.addChild(addEnemy(gameScene: self, groundHeight: groundHeight))
        }
        let holeCreate = SKAction.run {
            self.addChild(addHole(gameScene: self))
        }
        let enemySpawn = SKAction.sequence([enemyCreate, SKAction.wait(forDuration: 2), enemyCreate, SKAction.wait(forDuration: 2), holeCreate])
        let treeSpawn = SKAction.sequence([SKAction.wait(forDuration: TimeInterval(floatLiteral: random(min: 5, max: 15))), SKAction.run {
            self.addChild(createSingleTree(gameScene: self, iterator: nil, hasStarted: self.hasStarted))
        }])
        let hillsSpawn = SKAction.sequence([SKAction.wait(forDuration: TimeInterval(floatLiteral: random(min: 5, max: 10))), SKAction.run {
            self.addChild(addHills(gameScene: self))
        }])
        
        run(SKAction.sequence([SKAction.wait(forDuration: 8),SKAction.group([SKAction.repeatForever(enemySpawn), SKAction.repeatForever(treeSpawn), SKAction.repeatForever(hillsSpawn)])]))

    }
    
   
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState {
        case .showingLogo:
            gameState = .playing
            startLabel.removeFromParent()
            startGame()

        case .playing:
            addChild(shootArrow(gameScene: self, touches))
           
        case .dead:
            if let scene = GameScene(fileNamed: "GameScene") {
                let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 1)
                view?.presentScene(scene, transition: transition)
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if((firstBody.categoryBitMask & PhysicsCategory.Arrow != 0) &&
           (secondBody.categoryBitMask & PhysicsCategory.Enemy != 0 )) {
            arrowCollidesWithEnemy(arrow: firstBody.node as! SKSpriteNode, enemy: secondBody.node as! SKSpriteNode)
        }
        else if((firstBody.categoryBitMask & PhysicsCategory.Player != 0) &&
                (secondBody.categoryBitMask & PhysicsCategory.Enemy != 0 ))
        {
            if(isInvuln == false) {
                playerGotHit(enemy: secondBody.node as! SKSpriteNode)
            }
        }
        else if((firstBody.categoryBitMask & PhysicsCategory.Player != 0) &&
                (secondBody.categoryBitMask & PhysicsCategory.Hole != 0 )) {
//            physicsWorld.gravity = CGVectorMake(0.0, -9.8)
//            if let scene = GameScene(fileNamed: "GameScene") {
//                let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 1)
//                view?.presentScene(scene, transition: transition)
//            }
        }
    }
    
    
    func playerGotHit(enemy: SKSpriteNode){
        enemy.removeFromParent()
        playerLives -= 1
        if(playerLives < 1) {
            if let scene = GameScene(fileNamed: "GameScene") {
                let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 1)
                view?.presentScene(scene, transition: transition)
            }
        }
        isInvuln = true
    }
   
    
    override func update(_ currentTime: TimeInterval) {
        if(isInvuln == true){
            invulnTime += 0.1
        }

        if (invulnTime > 10) {
            isInvuln = false
            invulnTime = 0
        }
    }
}