//
//  TopBoundaryNode.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 13.11.2023.
//

import SpriteKit

final class TopBoundaryNode: SKNode {
    // MARK: Init
    init(width: CGFloat) {
        super.init()
        
        physicsBody = SKPhysicsBody(
            rectangleOf: CGSize(
                width: width,
                height: 1
            )
        )
        physicsBody?.isDynamic = false
        physicsBody?.friction = 0
        physicsBody?.restitution = 0
        physicsBody?.categoryBitMask = Physics.CategoryBitMask.sceneBorder
        physicsBody?.collisionBitMask = Physics.CollisionBitMask.sceneBorder
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
