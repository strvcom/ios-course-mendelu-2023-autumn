//
//  GameScene.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 12.11.2023.
//

import SpriteKit
import SwiftUI

final class GameScene: SKScene {
    // MARK: Properties
    private var bird: SKSpriteNode!
    
    // MARK: Overrides
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        
        scaleMode = .aspectFill
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        setupScene()
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if let velocity = bird?.physicsBody?.velocity.dy {
            let test = velocity.normalize(
                min: -2000,
                max: 2000,
                from: -(.pi / 2),
                to: .pi / 2
            )
            
            bird.zRotation = test
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        bird.physicsBody?.applyImpulse(
            CGVector(
                dx: 0,
                dy: bird.size.height
            )
        )
    }
}

// MARK: Private API
extension GameScene {
    func setupScene() {
        let background = Assets.background
        background.zPosition = Layer.background
        background.anchorPoint = .zero
        
        addChild(background)
        
        let base = Assets.base
        base.zPosition = Layer.base
        base.anchorPoint = .zero
        base.position = CGPoint(
            x: 0,
            y: -40
        )
        base.physicsBody = SKPhysicsBody(
            rectangleOf: base.size,
            center: CGPoint(
                x: base.size.width * 0.5,
                y: base.size.height * 0.5
            )
        )
        base.physicsBody?.categoryBitMask = Physics.CategoryBitMask.base
        base.physicsBody?.collisionBitMask = Physics.CollisionBitMask.base
        base.physicsBody?.affectedByGravity = false
        base.physicsBody?.isDynamic = false
        
        addChild(base)
        
        let birdTextures = Assets.bird.textures
        bird = SKSpriteNode(texture: birdTextures.first)
        bird.zPosition = Layer.bird
        bird.position = CGPoint(
            x: size.width / 2,
            y: size.height / 2
        )
        bird.run(
            SKAction.repeatForever(
                SKAction.animate(
                    with: birdTextures,
                    timePerFrame: 0.3,
                    resize: false,
                    restore: true
                )
            )
        )
        bird.physicsBody = SKPhysicsBody(rectangleOf: birdTextures.first?.size() ?? .zero)
        bird.physicsBody?.categoryBitMask = Physics.CategoryBitMask.bird
        bird.physicsBody?.collisionBitMask = Physics.CollisionBitMask.bird
        bird.physicsBody?.contactTestBitMask = Physics.ContactTestBitMask.bird
        
        addChild(bird)
    }
}
