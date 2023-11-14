//
//  GameStateInitial.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 14.11.2023.
//

import GameplayKit

final class GameStateInitial: GKState {
    // MARK: Properties
    private weak var game: Game?
    
    // MARK: Init
    init(game: Game) {
        self.game = game
    }
    
    // MARK: Overrides
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass is GameStateRunning.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        print("[GAME STATE] Initial")
        
        game?.openInitialScene()
    }
}
