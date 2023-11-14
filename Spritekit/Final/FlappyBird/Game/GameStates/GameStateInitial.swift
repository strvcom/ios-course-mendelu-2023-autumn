//
//  GameStateInitial.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 14.11.2023.
//

import GameplayKit

final class GameStateInitial: GKState {
    // MARK: Properties
    private unowned var gameViewController: GameViewController
    
    // MARK: Init
    init(gameViewController: GameViewController) {
        self.gameViewController = gameViewController
    }
    
    // MARK: Overrides
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass is GameStateRunning.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        print("[GAME STATE] Initial")
        
        gameViewController.openInitialScene()
    }
}
