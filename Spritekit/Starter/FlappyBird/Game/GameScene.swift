//
//  GameScene.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 28.11.2023.
//

import SpriteKit

final class GameScene: SKScene {
    private var bird: BirdNode!
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        
        scaleMode = .aspectFill
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        let background = BackgroundNode()
        
        let base = BaseNode()
        
        bird = BirdNode()
        
        let top = TopNode(width: size.width)
        
        addChild(top)
        addChild(bird)
        addChild(base)
        addChild(background)
        
        background.anchorPoint = .zero
        
        base.anchorPoint = .zero
        base.position = CGPoint(
            x: 0,
            y: -base.size.height * 0.3
        )
        
        bird.position = CGPoint(
            x: size.width * 0.5,
            y: size.height * 0.5
        )
        
        top.position = CGPoint(
            x: size.width * 0.5,
            y: size.height
        )
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        bird.flapWings()
    }
}
