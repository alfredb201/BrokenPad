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
    static let Enemy :UInt32 = 0b1
    static let Ravine :UInt32 = 0b10
    static let Arrow :UInt32 = 0b100
    static let Player :UInt32 = 0b1000
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
    
    var backgroundElements: [SKSpriteNode] = []
    var groundElements: [SKSpriteNode] = []
    var village: SKSpriteNode!
    var player: SKSpriteNode!
    var firepit: SKSpriteNode!
    var sky: SKSpriteNode!
    var startLabel: SKLabelNode!
    var gameState = GameState.showingLogo
    var groundHeight: CGFloat = 0.0
    var playerLives: Int = 3 {
        didSet{
            if(playerLives > 0){
                HUD.texture = SKTexture(imageNamed: "HUD\(playerLives)")
            }
        }
    }
    var isInvuln: Bool = false
    var invulnTime: TimeInterval = 0
    var HUD: SKSpriteNode!
    var hasStarted: Bool = false
    let groundTexture = SKTexture(imageNamed: "GameGround")
    let treeTexture = SKTexture(imageNamed: "Tree")
    let cloudTexture = SKTexture(imageNamed: "Cloud")
    let cloudsTexture = SKTexture(imageNamed: "Clouds")
    
  
    
    override func didMove(to view: SKView) {
        
        physicsWorld.gravity = CGVectorMake(0.0, 0)
        physicsWorld.contactDelegate = self
        setStartLabel()
        createSky()
        createGround()
        createBackground()

        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        upSwipe.direction = .up
        view.addGestureRecognizer(upSwipe)

       
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
                playerAtlas.textureNamed("ElfiorIdle5"),
                playerAtlas.textureNamed("ElfiorIdle6"),
                playerAtlas.textureNamed("ElfiorIdle7"),
                playerAtlas.textureNamed("ElfiorIdle8"),

            ]
        }
        
        let idleAnimation = SKAction.animate(with: playerIdleTextures, timePerFrame: 0.3)
        
        player.run(SKAction.repeatForever(idleAnimation), withKey: "ElfiorIdleAnimation")
    }
    
    func ElfiorRunningAnimation() {
        var playerAtlas: SKTextureAtlas {
            return SKTextureAtlas(named: "ElfiorIdle")
        }
        var playerIdleTextures: [SKTexture] {
            return [
                playerAtlas.textureNamed("ElfiorIdle1"),
                playerAtlas.textureNamed("ElfiorIdle2"),
                playerAtlas.textureNamed("ElfiorIdle3"),
                playerAtlas.textureNamed("ElfiorIdle4"),
                playerAtlas.textureNamed("ElfiorIdle5"),
                playerAtlas.textureNamed("ElfiorIdle6"),
                playerAtlas.textureNamed("ElfiorIdle7"),
                playerAtlas.textureNamed("ElfiorIdle8"),

            ]
        }
        
        let idleAnimation = SKAction.animate(with: playerIdleTextures, timePerFrame: 0.3)
        
        player.run(SKAction.repeatForever(idleAnimation), withKey: "ElfiorIdleAnimation")
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            switch sender.direction {
            case .up:
            // Call your jump function here
                if player.action(forKey: "jump") == nil { // check that there's no jump action running
                    let jumpUp = SKAction.moveBy(x: 10, y: 50, duration: 1)
                    let fallBack = SKAction.moveBy(x: -10, y: -50, duration: 1)

                    player.run(SKAction.sequence([jumpUp, fallBack]), withKey:"jump")
                  }
            default:
                break
            }
        }
    }
    
    func createSky() {
        let sky = SKSpriteNode(color: UIColor(ciColor: CIColor(red: 99/255, green: 167/255, blue: 241/255)), size: CGSize(width: frame.width, height: frame.height))
        sky.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        
        sky.position = CGPoint(x: frame.midX, y: frame.height)
        
        addChild(sky)
        
        sky.zPosition = -40
        
    }
    
    
    func createBackground() {
        createVillage()
        createPlayer()
        createFirepit()
        createClouds()
        createTrees()
    }
    
    func createVillage() {
        village = SKSpriteNode(imageNamed: "Village")
        village.zPosition = -20
        village.anchorPoint = CGPoint.zero
        village.position = CGPoint(x: size.width/20, y: groundHeight / 4.0)
        village.xScale = 0.9
        village.yScale = 0.9
        village.name = "village"
        addChild(village)
        backgroundElements.append(village)
    }
    
    func createGround(){
        for i in 0 ... 3 {
            let ground = SKSpriteNode(texture: groundTexture)
            ground.zPosition = 0
            ground.position = CGPoint(x: (ground.size.width / 2 + (ground.size.width * CGFloat(i))), y: groundTexture.size().height / 2)
            ground.physicsBody = SKPhysicsBody(texture: ground.texture!, size: ground.texture!.size())
            ground.physicsBody?.categoryBitMask = PhysicsCategory.Nobody
            ground.physicsBody?.collisionBitMask = PhysicsCategory.Player
            ground.physicsBody?.isDynamic = false
            addChild(ground)
            groundElements.append(ground)
            groundHeight = ground.size.height

             
        }
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
    func createPlayer() {
        let playerTexture = SKTexture(imageNamed: "Elfior")
        player = SKSpriteNode(texture: playerTexture)
        player.zPosition = 10
        player.position = CGPoint(x: frame.width / 2 - 30, y: groundHeight / 2.5)
        
        addChild(player)
        
        
        player.physicsBody = SKPhysicsBody(texture: playerTexture, size: playerTexture.size())
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        player.physicsBody?.collisionBitMask = PhysicsCategory.Nobody
        player.physicsBody?.isDynamic = false

    }
    
    func createFirepit(){
        let firepitTexture = SKTexture(imageNamed: "Firepit")
        firepit = SKSpriteNode(texture: firepitTexture)
        firepit.zPosition = -15
        firepit.setScale(3.0)
        firepit.position = CGPoint(x: player.position.x + 70, y: groundHeight / 2.5)
        
        addChild(firepit)
        backgroundElements.append(firepit)
    }
    
    func createClouds(){
        
        let numberOfClouds = Int(random(min: 7, max: 12))
        for _ in 0...numberOfClouds {
            createSingleCloud(hasStarted: hasStarted)
        }
    }
    
    func createSingleCloud(hasStarted: Bool){
        let cloud = SKSpriteNode(texture: random(min: 0, max: 10) < 6.0 ? cloudTexture : cloudsTexture)
        cloud.zPosition = -35
        cloud.yScale = random(min: 1.0, max: 3.0)
        cloud.xScale = random(min: 0, max: 100) < 50 ? cloud.yScale : -cloud.yScale
        cloud.position = CGPoint(x: !hasStarted ? frame.width * (random(min: 0, max: 3.0) / 3) : frame.width + cloudTexture.size().width, y: frame.height * random(min: 0.5, max: 0.9))
        addChild(cloud)
        
        let moveLeft = SKAction.move(to: CGPoint(x: -cloud.size.width, y: cloud.position.y), duration: cloud.position.x / 10)
        let moveReset = SKAction.removeFromParent()
        let create = SKAction.run {
            self.createSingleCloud(hasStarted: self.hasStarted)
        }
        let moveLoop = SKAction.sequence([moveLeft, create, moveReset])
        cloud.run(moveLoop)
    }
    
    func createTrees(){
        for i in 1...10 {
            createSingleTree(iterator: i, hasStarted: hasStarted)
        }
    }
    
    func createSingleTree(iterator: Int?, hasStarted: Bool){
        let tree = SKSpriteNode(texture: treeTexture)
        if(!hasStarted){
            tree.setScale(3.0)
            tree.zPosition = -30
            tree.position = CGPoint(x: frame.width * (0.1 * CGFloat(iterator!)), y: groundHeight / 2.5)
            backgroundElements.append(tree)
            addChild(tree)
        }
        else{
            tree.setScale(random(min: 0.5, max: 4.0))
            tree.position = CGPoint(x: frame.width + 200, y: groundHeight / 2.5)
            tree.zPosition = -30
            addChild(tree)
            let moveLeft = SKAction.move(to: CGPoint(x: -tree.size.width, y: tree.position.y), duration: tree.position.x / 20)
            let moveReset = SKAction.removeFromParent()
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            tree.run(moveLoop)
        }
        

    }
    func createHUD(){
        HUD = SKSpriteNode(texture: SKTexture(imageNamed: "HUD3"))
        HUD.size = CGSize(width: HUD.size.width / 2, height: HUD.size.height / 2)
        HUD.position = CGPoint(x: HUD.size.width / 1.5, y: frame.height)
        addChild(HUD)
    }
    func addEnemy() {
        let enemy = SKSpriteNode(imageNamed: "Ogre")
        enemy.position = CGPoint(x: size.width + enemy.size.width / 2, y: groundHeight / 2.5)
        enemy.zPosition = 10
        addChild(enemy)
        
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.isDynamic = false
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        enemy.physicsBody?.contactTestBitMask = PhysicsCategory.Arrow | PhysicsCategory.Player
        enemy.physicsBody?.collisionBitMask = PhysicsCategory.Nobody
        
        
        let randomDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))

        let moveAction = SKAction.move(to: CGPoint(x: -enemy.size.width/2, y: groundHeight / 2.5), duration: TimeInterval(randomDuration))
        let moveActionDone = SKAction.removeFromParent()
  
        enemy.run(SKAction.sequence([moveAction, moveActionDone]))
    }
    
    func addHills(){
        let hills = SKSpriteNode(imageNamed: "Hills")
        hills.position = CGPoint(x: size.width + 200, y: groundHeight / 2.5)
        hills.zPosition = -35
        hills.setScale(random(min: 5.0, max: 8.0))
        addChild(hills)

        let moveAction = SKAction.move(to: CGPoint(x: -hills.size.width/2, y: groundHeight / 2.5), duration: TimeInterval(hills.position.x / 20))
        let moveActionDone = SKAction.removeFromParent()
        
        hills.run(SKAction.sequence([moveAction, moveActionDone]))
    }
    func addRavine() {
        let ravineTexture = SKTexture(imageNamed: "Ravine")
        let ravine = SKSpriteNode(texture: ravineTexture)
        ravine.position = CGPoint(x: size.width + ravine.size.width / 2, y: groundHeight / 2)
        ravine.zPosition = 10
        
        addChild(ravine)
        
        ravine.physicsBody = SKPhysicsBody(texture: ravineTexture, size: CGSize(width: ravineTexture.size().width, height: ravineTexture.size().height))
        ravine.physicsBody?.isDynamic = false
        ravine.physicsBody?.categoryBitMask = PhysicsCategory.Ravine
        ravine.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        ravine.physicsBody?.collisionBitMask = PhysicsCategory.Nobody
        
        let randomDuration = random(min: CGFloat(3.0), max: CGFloat(6.0))

        let moveAction = SKAction.move(to: CGPoint(x: -ravine.size.width/2, y: groundHeight / 2), duration: TimeInterval(randomDuration))
        let moveActionDone = SKAction.removeFromParent()
        ravine.run(SKAction.sequence([moveAction, moveActionDone]))
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
        movePlayer()
        startGround()
        startIdleAnimation()
        for node in backgroundElements {
            let time = node.position.x / 100
            let isVillage = node.name == "village"
            let moveAction = SKAction.move(to: CGPoint(x: -node.frame.width, y: node.position.y), duration: isVillage ? 7 : time )
            node.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
        }
        createHUD()
        let enemySpawn = SKAction.sequence([SKAction.run(addEnemy), SKAction.wait(forDuration: 2), SKAction.run(addEnemy), SKAction.wait(forDuration: 2), SKAction.run(addRavine)])
        let treeSpawn = SKAction.sequence([SKAction.wait(forDuration: TimeInterval(floatLiteral: random(min: 5, max: 20))), SKAction.run {
            self.createSingleTree(iterator: nil, hasStarted: self.hasStarted)
        }])
        let hillsSpawn = SKAction.sequence([SKAction.wait(forDuration: TimeInterval(floatLiteral: random(min: 5, max: 20))), SKAction.run {
            self.addHills()
        }])
        
        run(SKAction.sequence([SKAction.wait(forDuration: 8),SKAction.group([SKAction.repeatForever(enemySpawn), SKAction.repeatForever(treeSpawn), SKAction.repeatForever(hillsSpawn)])]))

    }
    
    func movePlayer(){
        player.run(SKAction.move(to: CGPoint(x: 150, y: groundHeight / 2.4), duration: 3.0))
        player.physicsBody?.isDynamic = true
    }
    
    func shootArrow(_ touches: Set<UITouch>){
        let touch = touches.first
        let touchPosition = touch!.location(in: self)
        let arrow = SKSpriteNode(imageNamed: "Arrow")
        arrow.setScale(5.0)
        arrow.position = player.position
        
        let distance = touchPosition - arrow.position
        if (distance.x < 0) {return}
        
        addChild(arrow)
        
        arrow.physicsBody = SKPhysicsBody(circleOfRadius: arrow.size.width/4)
        arrow.physicsBody?.isDynamic = true
        arrow.physicsBody?.categoryBitMask = PhysicsCategory.Arrow
        arrow.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        arrow.physicsBody?.collisionBitMask = PhysicsCategory.Nobody
        arrow.physicsBody?.usesPreciseCollisionDetection = true
        let direction = distance.normalized()
        let maxDistance = direction * 800
        let realDistance = maxDistance + arrow.position
        
        let shootAction = SKAction.move(to: realDistance, duration: 1.0)
        let rotateAction = SKAction.rotate(toAngle: -(.pi / 4), duration: 2.0)
        let shootActionDone = SKAction.removeFromParent()
        arrow.run(SKAction.sequence([SKAction.group([shootAction, rotateAction]), shootActionDone]))

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState {
        case .showingLogo:
            gameState = .playing
            startLabel.removeFromParent()
            startGame()

        case .playing:
            shootArrow(touches)
           
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
                (secondBody.categoryBitMask & PhysicsCategory.Ravine != 0 )) {
            physicsWorld.gravity = CGVectorMake(0.0, -9.8)
            if let scene = GameScene(fileNamed: "GameScene") {
                let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 1)
                view?.presentScene(scene, transition: transition)
            }
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
    func arrowCollidesWithEnemy(arrow: SKSpriteNode, enemy: SKSpriteNode) {
        arrow.removeFromParent()
        
        enemy.removeFromParent()
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
