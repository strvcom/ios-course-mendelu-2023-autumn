//
//  TopNode.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 28.11.2023.
//

import SpriteKit

final class TopNode: SKNode {
    init(width: CGFloat) {
        super.init()
        
        physicsBody = SKPhysicsBody(
            rectangleOf: CGSize(
                width: width,
                height: 1
            )
        )
        physicsBody?.categoryBitMask = Physics.CategoryBitMask.sceneBorder
        physicsBody?.collisionBitMask = Physics.CollisionBitMask.sceneBorder
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
