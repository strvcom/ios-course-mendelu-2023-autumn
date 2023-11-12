//
//  GameScene.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 12.11.2023.
//

import SpriteKit
import SwiftUI

final class GameScene: SKScene {
    // MARK: Overrides
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        
        scaleMode = .aspectFill
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        setupScene()
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
        base.position = CGPoint(
            x: 0,
            y: -40
        )
        base.anchorPoint = .zero
        
        addChild(base)
        
        let birdTextures = Assets.bird.textures
        let bird = SKSpriteNode(texture: birdTextures.first)
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
        
        addChild(bird)
    }
}
