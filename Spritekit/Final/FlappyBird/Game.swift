//
//  GameViewModel.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 14.11.2023.
//

import SwiftUI
import SpriteKit
import GameplayKit

final class Game {
    // MARK: Properties
    @Published private(set) var scene = SKScene()
    
    private let sceneSize = BackgroundNode().size
    
    private lazy var gameState = GKStateMachine(
        states: [
            GameStateInitial(game: self),
            GameStateRunning(game: self),
            GameStateFinished()
        ]
    )
    
    // MARK: Init
    init() {
        gameState.enter(GameStateInitial.self)
    }
}

// MARK: ObservedObject
extension Game: ObservableObject {}

// MARK: Public API
extension Game {
    func openInitialScene() {
        scene = GameInitialScene(
            size: sceneSize,
            gameState: gameState
        )
    }
    
    func openGameScene() {
        scene = GameScene(
            size: sceneSize,
            gameState: gameState
        )
    }
}
