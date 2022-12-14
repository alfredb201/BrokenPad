//
//  Arrow.swift
//  Elfior
//
//  Created by Pierpaolo Siciliano on 13/12/22.
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

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

func shootArrow(scene: SceneModel, _ touches: Set<UITouch>) -> SKSpriteNode {
    let touchPosition = touches.first!.location(in: scene)
    let arrow = SKSpriteNode(imageNamed: "Arrow")
    arrow.setScale(5.0)
    arrow.position = elfior.position
    arrow.position.y = elfior.position.y + 30
    arrow.isHidden = true
    
    let distance = touchPosition - arrow.position
    
    arrow.physicsBody = SKPhysicsBody(circleOfRadius: arrow.size.width / 4)
    arrow.physicsBody?.categoryBitMask = PhysicsCategory.arrow.rawValue
    arrow.physicsBody?.contactTestBitMask = PhysicsCategory.enemy.rawValue
    arrow.physicsBody?.collisionBitMask = PhysicsCategory.nothing.rawValue
    arrow.physicsBody?.isDynamic = true
    arrow.physicsBody?.usesPreciseCollisionDetection = true
    
    let direction = distance.normalized()
    let maxDistance = direction * 800
    let realDistance = maxDistance + arrow.position
    
    let shootAction = SKAction.move(to: realDistance, duration: 1.0)
    let rotateAction = SKAction.rotate(toAngle: -(.pi / 4), duration: 3.0)
    let shootActionDone = SKAction.removeFromParent()
    let showArrow = SKAction.run {
        arrow.isHidden = false
    }
    ElfiorAttackAnimation()
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(220)) {
        arrow.run(SKAction.sequence([showArrow ,SKAction.group([shootAction, rotateAction]), shootActionDone]))
    }
    return arrow
}

func arrowCollidesWithEnemy(arrow: SKSpriteNode, enemy: SKSpriteNode) {
    arrow.removeFromParent()
    enemy.removeAllActions()
    enemy.physicsBody?.categoryBitMask = 0
    enemyDeathAnimation(enemy: enemy)
    enemy.run(SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.removeFromParent()]))
}
