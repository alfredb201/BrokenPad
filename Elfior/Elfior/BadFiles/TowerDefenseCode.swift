//
//  GameScene.swift
//  TowerDefense
//
//  Created by Mattia Ferrara on 08/12/22.
//

import SpriteKit



func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}
func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}
func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}
#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
    }
#endif
extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

class TowerDefenseCode: SKScene, SKPhysicsContactDelegate {
    
    var enemyKilled = 0
    let tower = SKSpriteNode(imageNamed: "Tower")
    let background = SKSpriteNode(imageNamed: "Background")
    override func didMove(to view: SKView) {
        
        background.zPosition = -1
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = frame.size
        addChild(background)
        
        tower.position = CGPoint(x: size.width * 0.1, y: size.height / 2)
        addChild(tower)
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addEnemy), SKAction.wait(forDuration: 1.0)])))
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        scene?.scaleMode = .aspectFill
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(0xFFFFFFFF))
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addEnemy() {
        let enemy = SKSpriteNode(imageNamed: "Ogre")
        let randomY = random(min: enemy.size.height / 2, max: size.height - enemy.size.height / 2)
        enemy.position = CGPoint(x: size.width + enemy.size.width / 2, y: randomY)
        
        addChild(enemy)
        
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        enemy.physicsBody?.contactTestBitMask = PhysicsCategory.Arrow
        enemy.physicsBody?.collisionBitMask = PhysicsCategory.Nobody
        
        let randomDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))

        let moveAction = SKAction.move(to: CGPoint(x: -enemy.size.width/2, y: randomY), duration: TimeInterval(randomDuration))
        let moveActionDone = SKAction.removeFromParent()
        
//                let defeatAction = SKAction.run() {
//                    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
//                    let gameOverScene = GameOverScene(size: self.size, hasWon: false)
//                    self.view?.presentScene(gameOverScene, transition: reveal)
//                    }
        enemy.run(SKAction.sequence([moveAction, moveActionDone]))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchPosition = touch!.location(in: self)
        
        let arrow = SKSpriteNode(imageNamed: "Firepit")
        arrow.position = tower.position
        
        let distance = touchPosition - arrow.position
        if (distance.x < 0) {return}
        
        addChild(arrow)
        
        arrow.physicsBody = SKPhysicsBody(circleOfRadius: arrow.size.width/2)
        arrow.physicsBody?.isDynamic = true
        arrow.physicsBody?.categoryBitMask = PhysicsCategory.Arrow
        arrow.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        arrow.physicsBody?.collisionBitMask = PhysicsCategory.Nobody
        arrow.physicsBody?.usesPreciseCollisionDetection = true
        
        let direction = distance.normalized()
        let maxDistance = direction * 1000
        let realDistance = maxDistance + arrow.position
        
        let shootAction = SKAction.move(to: realDistance, duration: 2.0)
        let shootActionDone = SKAction.removeFromParent()
        arrow.run(SKAction.sequence([shootAction, shootActionDone]))
    }
    
    func arrowCollidesWithEnemy(arrow: SKSpriteNode, enemy: SKSpriteNode) {
        enemyKilled += 1
        //        if(enemyKilled >= 20){
        //            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        //            let gameOverScene = GameOverScene(size: self.size, hasWon: true)
        //            self.view?.presentScene(gameOverScene, transition: reveal)
        
        
        arrow.removeFromParent()
        
        enemy.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if((firstBody.categoryBitMask & PhysicsCategory.Enemy != 0) &&
           (secondBody.categoryBitMask & PhysicsCategory.Arrow != 0 )) {
            arrowCollidesWithEnemy(arrow: firstBody.node as! SKSpriteNode, enemy: secondBody.node as! SKSpriteNode)
        }
    }
}
