//
//  GameStateRunning.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 13.11.2023.
//

import GameplayKit

final class GameStateRunning: GKState {
    // MARK: Overrides
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass is GameStateFinished.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        print("[GAME STATE] Running")
    }
}
