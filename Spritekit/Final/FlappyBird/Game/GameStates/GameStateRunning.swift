//
//  GameStateRunning.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 13.11.2023.
//

import GameplayKit

final class GameStateRunning: GKState {
    // MARK: Properties
    private unowned var gameViewController: GameViewController
    
    // MARK: Init
    init(gameViewController: GameViewController) {
        self.gameViewController = gameViewController
    }
    
    // MARK: Overrides
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass is GameStateFinished.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        print("[GAME STATE] Running")
        
        gameViewController.openGameScene()
    }
}
