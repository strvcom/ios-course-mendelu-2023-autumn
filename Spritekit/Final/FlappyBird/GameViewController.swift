//
//  GameViewController.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 14.11.2023.
//

import UIKit
import SpriteKit
import GameplayKit

final class GameViewController: UIViewController {
    // MARK: Properties
    private let size = BackgroundNode().size
    
    private lazy var gameState = GKStateMachine(
        states: [
            GameStateInitial(gameViewController: self),
            GameStateRunning(gameViewController: self),
            GameStateFinished()
        ]
    )
    
    private var skView: SKView {
        view as! SKView
    }
    
    // MARK: Lifecycle
    override func loadView() {
        view = SKView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameState.enter(GameStateInitial.self)
    }
}

// MARK: Public API
extension GameViewController {
    func openInitialScene() {
        skView.presentScene(
            GameInitialScene(
                size: size,
                gameState: gameState
            ),
            transition: .crossFade(withDuration: 0.5)
        )
    }
    
    func openGameScene() {
        skView.presentScene(
            GameScene(
                size: size,
                gameState: gameState
            ),
            transition: .crossFade(withDuration: 0.5)
        )
    }
}
