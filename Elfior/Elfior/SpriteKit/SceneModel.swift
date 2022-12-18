//
//  SceneModel.swift
//  Elfior
//
//  Created by Pierpaolo Siciliano on 12/12/22.
//

import SpriteKit

/* enumerator that contains the ids of the hitboxes and that will be used to
 handle the different cases of collision with entities */
enum PhysicsCategory: UInt32 {
    case nothing = 0b0 // 0
    case ground = 0b1 // 1
    case enemy = 0b10 // 2
    case trap = 0b100 // 4
    case arrow = 0b1000 // 8
    case player = 0b10000 // 16
}

enum GameState {
    case showingLogo
    case playing
    case dead
}

class SceneModel: SKScene, SKPhysicsContactDelegate {
    var background = Landscape()
    
    var actualNumberOfClouds = 1 {
        didSet {
            if actualNumberOfClouds == 0 {
                actualNumberOfClouds = background.numberOfClouds
            }
            let cloudSpawn = SKAction.run {
                self.addChild(self.background.createSingleCloud(scene: self, firstClouds: false))
            }
            run(cloudSpawn)
        }
    }
    var startLabel: SKSpriteNode!
    var jumpButton: SKSpriteNode!
    var shootButton: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var gameOver: SKSpriteNode!
    var retryButton: SKSpriteNode!
    
    var gameState = GameState.showingLogo
    var playerLives: Int = 3 {
        didSet {
            if (playerLives >= 0) {
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
    var isShooting: Bool = false
    var attackDelay: TimeInterval = 0
    let backgroundSound = SKAudioNode(fileNamed: "ElfiorTheme.wav")
    let arrowSound: SKAudioNode = SKAudioNode(fileNamed: "ArrowSound.mp3")
    let jumpSound: SKAudioNode = SKAudioNode(fileNamed: "MarioJumpSound.wav")
    var spawnSpeed: Int = 7
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVectorMake(0.0, -4)
        physicsWorld.contactDelegate = self
        setStartLabel()
        setGameOver()
        setRetryButton()
        createBackground()
        
        addChild(backgroundSound)
        
       
    }
    
    func createBackground() {
        for ground in background.createGround(){
            addChild(ground)
        }
        addChild(background.createSky(scene: self))
        addChild(background.createVillage(scene: self))
        addChild(createPlayer(scene: self, groundHeight: background.groundHeight))
        ElfiorIdleAnimation()
        addChild(background.createFirepit())
        addChild(background.createMoon(scene: self))
        addChild(background.createLogo(scene: self))
        for hill in background.addHill(scene: self) {
            addChild(hill)
        }
        for cloud in background.createClouds(scene: self) {
            addChild(cloud)
        }
        for tree in background.createTrees(scene: self) {
            addChild(tree)
        }
    }
    
    func setStartLabel() {
        startLabel = SKSpriteNode(imageNamed: "TapToStart")
        startLabel.position = CGPoint(x: frame.midX, y: frame.midY - 170)
        startLabel.zPosition = 10
        addChild(startLabel)
    }
    
    func setJumpButton() {
        
        
        jumpButton = SKSpriteNode(imageNamed: "JumpButton")
        jumpButton.position = CGPoint(x: frame.width * 0.1, y: frame.height * 0.075)
        jumpButton.setScale(2.0)
        jumpButton.zPosition = 15
        
        let jumpButtonHitArea = SKShapeNode(rectOf: CGSize(width: 200, height: 300))
        jumpButtonHitArea.position = jumpButton.position
        jumpButtonHitArea.name = "jumpButton"
        jumpButtonHitArea.fillColor = UIColor.clear
        jumpButtonHitArea.strokeColor = UIColor.clear
        jumpButtonHitArea.zPosition = 20
        
        
        addChild(jumpButton)
        addChild(jumpButtonHitArea)
    }
    
    func setShootButton() {
        shootButton = SKSpriteNode(imageNamed: "ShootButton")
        shootButton.position = CGPoint(x: frame.width * 0.9, y: frame.height * 0.075)
        shootButton.setScale(2.0)
        shootButton.zPosition = 15
        
        let shootButtonHitArea = SKShapeNode(rectOf: CGSize(width: 200, height: 300))
        shootButtonHitArea.position = shootButton.position
        shootButtonHitArea.name = "shootButton"
        shootButtonHitArea.fillColor = UIColor.clear
        shootButtonHitArea.strokeColor = UIColor.clear
        shootButtonHitArea.zPosition = 20
        
        addChild(shootButton)
        addChild(shootButtonHitArea)
    }
    
    func setGameOver() {
        gameOver = SKSpriteNode(imageNamed: "GameOver")
        gameOver.position = CGPoint(x: frame.midX, y: frame.midY - 170)
        gameOver.zPosition = 10
        gameOver.isHidden = true
        addChild(gameOver)
    }
    
    func setRetryButton() {
        retryButton = SKSpriteNode(imageNamed: "Retry")
        retryButton.name = "retryButton"
        retryButton.position = CGPoint(x: frame.midX, y: frame.midY * 1.5)
        retryButton.zPosition = 10
        retryButton.isHidden = true
        addChild(retryButton)
    }
    
    func startGame() {
        hasStarted = true
        startLabel.isHidden = true
        movePlayer(groundHeight: background.groundHeight)
        createScore()
        setJumpButton()
        setShootButton()
        ElfiorRunningAnimation()
        
        
        for node in background.backgroundElements {
            var time: Int = 0
            switch (node.name) {
            case "village":
                time = 7
            case "firepit":
                time = 5
            default:
                time = Int(node.position.x / 80)
            }
            let moveAction = SKAction.move(
                to: CGPoint(x: -node.frame.width, y: node.position.y),
                duration: TimeInterval(time)
            )
            node.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
        }
       
        enumerateChildNodes(withName: "logo", using: ({
            (node, error) in
            let moveLogo = SKAction.moveBy(x: 0, y: 220, duration: 2)
            node.run(SKAction.sequence([moveLogo, SKAction.removeFromParent()]))
        }))

        addChild(background.createHUD(scene: self))
        
        let enemyCreate = SKAction.run {
            switch (Int.random(in: 0...9)) {
            case 0...3:
                self.addChild(addOgre(scene: self, groundHeight: self.background.groundHeight))
            case 4...6:
                let shieldedOgre = addShieldedOgre(scene: self, groundHeight: self.background.groundHeight)
                self.addChild(shieldedOgre.0)
                self.addChild(shieldedOgre.1)
            case 7...9:
                self.addChild(addArmoredOgre(scene: self, groundHeight: self.background.groundHeight))
            default:
                print("An error occurred while declaring enemyCreate")
            }
        }
        
        let trapSpawn = SKAction.sequence([
            SKAction.wait(forDuration: TimeInterval(spawnSpeed + 2)),
            SKAction.run {
                let trap = self.background.addTrap(scene: self)
                self.addChild(trap.0)
                self.addChild(trap.1)
            }
        ])
        let enemySpawn = SKAction.sequence([
            enemyCreate,
            SKAction.wait(forDuration: TimeInterval(spawnSpeed))
        ])

        let treeSpawn = SKAction.sequence([
            SKAction.wait(forDuration: TimeInterval(Double.random(in: 3...6))),
            SKAction.run {
                self.addChild(self.background.createSingleTree(
                    scene: self,
                    iterator: nil,
                    hasStarted: self.hasStarted
                ))
            }
        ])
        run(SKAction.repeatForever(treeSpawn))
        run(SKAction.sequence([
            SKAction.wait(forDuration: 6),
            SKAction.group([
                SKAction.repeatForever(enemySpawn),
                SKAction.repeatForever(trapSpawn)
            ])
        ]))
        
    }
    
    func moveGround() {
        enumerateChildNodes(withName: "ground", using: ({
            (node, error) in
            node.position.x -= 1
            if node.position.x < -node.frame.width / 2 {
                node.position.x += node.frame.width * 2
            }
        }))
    }
    
    func moveHills() {
        enumerateChildNodes(withName: "hill", using: ({
            (node, error) in
            node.position.x -= 1
            if node.position.x < -node.frame.width / 2 {
                node.position.x += node.frame.width * 2
            }
        }))
    }
    
    
    func createScore() {
        scoreLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        scoreLabel.text = "SCORE: 0"
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = UIColor.black
        scoreLabel.position = CGPoint(x: frame.maxX - 125, y: frame.maxY - 60)
        
        addChild(scoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState {
        case .showingLogo:
            gameState = .playing
            startLabel.removeFromParent()
            startGame()
        case .playing:
            let location = touches.first!.location(in: self)
            let touchedNode = atPoint(location)
            let pauseJump = SKAction.run {
                elfior.speed = 0
            }
            let resumeJump = SKAction.run {
                elfior.speed = 1
            }
            if touchedNode.name == "jumpButton" {
                if (elfior.position.y < background.groundHeight / 3.5) {
                    
                    //check that there's no jump action running
                    
                    run(SKAction.playSoundFileNamed("MarioJumpSound", waitForCompletion: false))
                    elfior.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
                    run(SKAction.sequence([pauseJump, SKAction.wait(forDuration: 1.3), resumeJump]))
                }
            }
            else if (touchedNode.name == "shootButton") {
                let shootArrowAction = SKAction.run {
                    if (elfior.position.y < self.background.groundHeight / 3.5 && !self.isShooting) {
                        self.addChild(shootArrow(scene: self, touches))
                        self.isShooting = true
                        self.attackDelay = 0
                        self.run(SKAction.playSoundFileNamed("ArrowSound", waitForCompletion: false))
                    }
                }
                run(shootArrowAction)
            }
        case .dead:
            let location = touches.first!.location(in: self)
            let touchedNode = atPoint(location)
            if touchedNode.name == "retryButton" {
                if let scene = SceneModel(fileNamed: "Scene") {
                    let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 1)
                    view?.presentScene(scene, transition: transition)
                }
            }
        }

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if (contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask) {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (
            (firstBody.categoryBitMask & PhysicsCategory.arrow.rawValue != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.enemy.rawValue != 0)
        ) {
            if(arrowCollidesWithEnemy(arrow: firstBody.node as! SKSpriteNode, enemy: secondBody.node as! SKSpriteNode)) {
                score += 10
            }
        } else if (
            (firstBody.categoryBitMask & PhysicsCategory.player.rawValue != 0) &&
            ((secondBody.categoryBitMask & PhysicsCategory.enemy.rawValue != 0) || (secondBody.categoryBitMask & PhysicsCategory.trap.rawValue != 0))
        ) {
            if(secondBody.node?.name == "trapScore" || secondBody.node?.name == "shieldedOgreScore"){
                secondBody.categoryBitMask = PhysicsCategory.nothing.rawValue
                let scoreAction = SKAction.run {
                    self.score += 15
                }
                run(SKAction.sequence([SKAction.wait(forDuration: 1), scoreAction]))
            }
            else{
                if (isInvuln == false) {
                    playerGotHit(enemy: secondBody.node as! SKSpriteNode)
                }
            }
        }
    }
    
    
        func playerGotHit(enemy: SKSpriteNode) {
            ElfiorHitAnimation()
            playerLives -= 1
            if (playerLives < 1) {
                gameState = .dead
                let deathDelay = SKAction.run {
                    ElfiorDeathAnimation()
                }
                let deathAction = SKAction.run {
                    self.isPaused = true
                    self.gameOver.isHidden = false
                    self.retryButton.isHidden = false
                }
                run(SKAction.sequence([deathDelay, SKAction.wait(forDuration: 2), deathAction]))
            }
            isInvuln = true
            ElfiorRunningAnimation()
        }
    
        
        override func update(_ currentTime: TimeInterval) {
            if hasStarted {
                moveGround()
                moveHills()
            }
            
            if attackDelay == 0 {
                attackDelay = currentTime
            }
            if currentTime - attackDelay > 1 {
                isShooting = false
            }
            
            if (isInvuln == true) {
                invulnTime += 0.1
            }
            if (invulnTime > 10) {
                isInvuln = false
                invulnTime = 0
            }
        }
    }

