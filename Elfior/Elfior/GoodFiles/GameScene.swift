//
//  GameScene.swift
//  Elfior
//
//  Created by Mattia Ferrara on 09/12/22.
//

import SpriteKit

/* this struct contains the id of the hitboxes and it will be used to
 handle the different cases of collision with entities */

enum PhysicsCategory: UInt32 {
    case nothing = 0b0 // 0
    case ground = 0b1 // 1
    case enemy = 0b10 // 2
    case pit = 0b100 // 4
    case arrow = 0b1000 // 8
    case player = 0b10000 // 16
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
    
    var background = BackgroundElements()
    
    var actualNumberOfClouds = 1 {
        didSet{
            if actualNumberOfClouds == 0{
                actualNumberOfClouds = background.numberOfClouds
            }
            let cloudSpawn = SKAction.run {
                self.addChild(self.background.createSingleCloud(gameScene: self, firstClouds: false))
            }
            run(cloudSpawn)
        }
    }
    var startLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var gameState = GameState.showingLogo
    var playerLives: Int = 3 {
        didSet{
            if(playerLives > 0){
                background.HUD.texture = SKTexture(imageNamed: "HUD\(playerLives)")
            }
        }
    }
    var isInvuln: Bool = false
    var invulnTime: TimeInterval = 0
    var hasStarted: Bool = false
    var score = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }
    var timeGroundSpawn = 1.0

    
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
                    elfior.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 150))
                }
            default:
                break
            }
        }
    }
    
    func createBackground(){
        for ground in background.createGround() {
            addChild(ground)
        }
        addChild(background.createSky(gameScene: self))
        addChild(background.createVillage(gameScene: self))
        addChild(createPlayer(gameScene: self, groundHeight: background.groundHeight))
        addChild(background.createFirepit())
        
        for cloud in background.createClouds(gameScene: self) {
            addChild(cloud)
        }
        for tree in background.createTrees(gameScene: self) {
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
        movePlayer(groundHeight: background.groundHeight)
        createScore()
        ElfiorRunningAnimation()
        background.startGround()
        let holeSpawn = SKAction.run {
//            if(random(min: 0, max: 100) < 20){
//            }
        }
        let movingGroundSpawn = SKAction.sequence([SKAction.run {
            if(random(min: 0, max: 100) > 20){
                self.addChild(self.background.createMovingGround(gameScene: self))
                self.timeGroundSpawn = 2.2
            }
            else{
                self.addChild(self.background.addHole(gameScene: self))
                print("hole")
                self.timeGroundSpawn = 0.5
            }
        },SKAction.wait(forDuration: timeGroundSpawn)])
        run(SKAction.repeatForever(movingGroundSpawn))
        for node in background.backgroundElements {
            let time = node.name == "ground" ? node.position.x / 100 : node.position.x / 100
            let isVillage = node.name == "village"
            let moveAction = SKAction.move(to: CGPoint(x: -node.frame.width, y: node.position.y), duration: isVillage ? 7 : time )
            node.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
        }
        
        addChild(background.createHUD(gameScene: self))
        let enemyCreate = SKAction.run {
            if(random(min: 0, max: 90) < 30) {
                self.addChild(addOgre(gameScene: self, groundHeight: self.background.groundHeight))
            }
            else if(random(min: 0, max: 90) > 60) {
                self.addChild(addArmoredOgre(gameScene: self, groundHeight: self.background.groundHeight))
            }
            else {
                self.addChild(addShieldedOgre(gameScene: self, groundHeight: self.background.groundHeight))
            }
        }
        let holeCreate = SKAction.run {
            self.addChild(self.background.addHole(gameScene: self))
        }
        let enemySpawn = SKAction.sequence([enemyCreate, SKAction.wait(forDuration: 4), enemyCreate, SKAction.wait(forDuration: 4)])
        let treeSpawn = SKAction.sequence([SKAction.wait(forDuration: TimeInterval(floatLiteral: random(min: 5, max: 15))), SKAction.run {
            self.addChild(self.background.createSingleTree(gameScene: self, iterator: nil, hasStarted: self.hasStarted))
        }])
        let hillsSpawn = SKAction.sequence([SKAction.wait(forDuration: TimeInterval(floatLiteral: random(min: 5, max: 10))), SKAction.run {
            self.addChild(self.background.addHills(gameScene: self))
        }])
        
        run(SKAction.sequence([SKAction.wait(forDuration: 6),SKAction.group([SKAction.repeatForever(enemySpawn), SKAction.repeatForever(treeSpawn), SKAction.repeatForever(hillsSpawn)])]))
        
    }
    
    func createScore() {
        scoreLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        scoreLabel.fontSize = 20
        
        scoreLabel.position = CGPoint(x: frame.maxX - 125, y: frame.maxY - 60)
        scoreLabel.text = "SCORE: 0"
        scoreLabel.fontColor = UIColor.black
        
        addChild(scoreLabel)
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
        
        if((firstBody.categoryBitMask & PhysicsCategory.arrow.rawValue != 0) &&
           (secondBody.categoryBitMask & PhysicsCategory.enemy.rawValue != 0 )) {
            arrowCollidesWithEnemy(arrow: firstBody.node as! SKSpriteNode, enemy: secondBody.node as! SKSpriteNode)
            if(secondBody.node?.name == "ogre"){
                score += 10
            }
            else if(secondBody.node?.name == "armoredOgre" || secondBody.node?.name == "shieldedOgre"){
                score += 20
            }
        }
        else if((firstBody.categoryBitMask & PhysicsCategory.player.rawValue != 0) &&
                (secondBody.categoryBitMask & PhysicsCategory.enemy.rawValue != 0 ))
        {
            if(isInvuln == false) {
                playerGotHit(enemy: secondBody.node as! SKSpriteNode)
            }
        }
        
//        else if((firstBody.categoryBitMask & PhysicsCategory.player.rawValue != 0) &&
//                (secondBody.categoryBitMask & PhysicsCategory.pit.rawValue != 0 )) {
//            physicsWorld.gravity = CGVectorMake(0.0, -9.8)
//            SKAction.wait(forDuration: 5)
//            if let scene = GameScene(fileNamed: "GameScene") {
//                let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 1)
//                view?.presentScene(scene, transition: transition)
//            }
//        }
        
        
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


