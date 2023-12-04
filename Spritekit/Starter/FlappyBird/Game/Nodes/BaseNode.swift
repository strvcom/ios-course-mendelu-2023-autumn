//
//  BaseNode.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 12.11.2023.
//

import SpriteKit

final class BaseNode: SKSpriteNode {
    // MARK: Init
    init() {
        let texture = SKTexture(imageNamed: Assets.Textures.base)
        
        super.init(
            texture: texture,
            color: .clear,
            size: texture.size()
        )
        
        zPosition = Layer.base
        
        physicsBody = SKPhysicsBody(
            rectangleOf: size,
            center: CGPoint(
                x: size.width * 0.5,
                y: size.height * 0.5
            )
        )
        physicsBody?.categoryBitMask = Physics.CategoryBitMask.base
        physicsBody?.collisionBitMask = Physics.CollisionBitMask.base
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
