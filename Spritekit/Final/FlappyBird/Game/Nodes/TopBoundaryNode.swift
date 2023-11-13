//
//  TopBoundaryNode.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 13.11.2023.
//

import SpriteKit

final class TopBoundaryNode: SKNode {
    // MARK: Init
    init(gameSceneSize: CGSize) {
        super.init()
        
        position = CGPoint(
            x: 0,
            y: gameSceneSize.height
        )
        physicsBody = SKPhysicsBody(
            rectangleOf: CGSize(
                width: gameSceneSize.width,
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
