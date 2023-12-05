//
//  GameStateFinished.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 13.11.2023.
//

import GameplayKit

final class GameStateFinished: GKState {
    // MARK: Overrides
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass is GameStateInitial.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        print("[GAME STATE] Finished")
    }
}
