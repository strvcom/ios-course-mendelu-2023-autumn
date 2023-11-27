//
//  GameInitialScene.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 14.11.2023.
//

import SpriteKit
import GameplayKit

final class GameInitialScene: SKScene {
    // MARK: Properties
    private let gameState: GKStateMachine
    
    // MARK: Init
    init(
        size: CGSize,
        gameState: GKStateMachine
    ) {
        self.gameState = gameState
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Overrides
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        
        scaleMode = .aspectFill
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        let getReadyNode = GetReadyNode()
        
        addChild(BackgroundNode())
        addChild(BaseNode())
        addChild(getReadyNode)
        
        getReadyNode.position = center
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        gameState.enter(GameStateRunning.self)
    }
}
