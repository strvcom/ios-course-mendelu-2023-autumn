//
//  GameScene.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 12.11.2023.
//

import SpriteKit
import SwiftUI
import AVFoundation
import GameplayKit

final class GameScene: SKScene {
    // MARK: Properties
    private let gameState: GKStateMachine
    private var bird: BirdNode!
    private var base: BaseNode!
    private var score: ScoreNode!
    private var pointSound: SKAction!
    private var hitSound: SKAction!
    
    private var pipes: [PipeNode] {
        children.compactMap { $0 as? PipeNode }
    }
    
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
        
        // MARK: Create children
        let topBoundaryNode = TopBoundaryNode(width: size.width)
        
        bird = BirdNode()
        
        base = BaseNode()
        
        score = ScoreNode()
        
        // MARK: Add children into the scene
        addChild(BackgroundNode())
        addChild(base)
        addChild(bird)
        addChild(score)
        addChild(topBoundaryNode)
        
        // MARK: Position children on the scene
        topBoundaryNode.position = CGPoint(
            x: 0,
            y: size.height
        )
        
        bird.position = CGPoint(
            x: size.width * 0.3,
            y: center.y + base.size.height
        )
        
        positionScoreNode()
        
        // MARK: Physics setup
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(
            dx: 0,
            dy: -5
        )
        
        // MARK: Sounds setup
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("AVAudioSession setup error \(error)")
        }
        
        pointSound = SKAction.playSoundFileNamed(
            Assets.Sounds.point,
            waitForCompletion: false
        )
        
        hitSound = SKAction.playSoundFileNamed(
            Assets.Sounds.hit,
            waitForCompletion: false
        )
        
        // MARK: Spawn pipe when the game starts
        spawnPipe()
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        bird.updateRotation()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        switch gameState.currentState {
        case gameState.currentState as GameStateRunning:
            bird.flapWings()
        case gameState.currentState as GameStateFinished:
            gameState.enter(GameStateInitial.self)
        default:
            break
        }
    }
}

// MARK: SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard gameState.currentState is GameStateRunning else {
            return
        }
        
        let contactBody = if contact.bodyA.node?.name == NodeName.bird {
            contact.bodyB
        } else {
            contact.bodyA
        }
        
        switch contactBody.node?.name {
        case NodeName.pipe, NodeName.base:
            endGame()
        case NodeName.pipeHole:
            increaseScore(node: contactBody.node)
        default:
            break
        }
    }
}

// MARK: Public API
extension GameScene {
    func onSafeAreaChange() {
        positionScoreNode()
    }
}

// MARK: Private API
private extension GameScene {
    func spawnPipe() {
        let holeHeight = bird.size.height * 4
        
        let lastPipeYPosition = pipes.last?.position.y ?? center.y
        
        let randomOffset = CGFloat.random(in: -150 ... 150)
        
        let topYOffsetTreshold = size.height - holeHeight * 0.5
        
        let bottomYOffsetTreshold = base.position.y + base.size.height + holeHeight * 0.5
        
        let pipeYPosition: CGFloat = {
            var pipeYPosition = lastPipeYPosition + randomOffset
            // If newly calculated y position is above the screen or bellow
            // the base, then instead of adding value to lastPipeYPosition
            // we substract it to move the pipe to other direction.
            if pipeYPosition > topYOffsetTreshold
                || pipeYPosition < bottomYOffsetTreshold {
                return lastPipeYPosition - randomOffset
            } else {
                return pipeYPosition
            }
        }()
        
        let pipe = PipeNode(holeHeight: holeHeight)
        pipe.position = CGPoint(
            x: size.width + pipe.width * 0.5,
            y: pipeYPosition
        )
        
        addChild(pipe)
        
        pipe.run(
            .group([
                .sequence([
                    .move(
                        to: CGPoint(
                            x: -pipe.width * 0.5,
                            y: pipeYPosition
                        ),
                        duration: 5
                    ),
                    .removeFromParent()
                ]),
                .sequence([
                    .wait(forDuration: 2.5),
                    .run { [weak self] in
                        self?.spawnPipe()
                    }
                ])
            ])
        )
    }
    
    func endGame() {
        gameState.enter(GameStateFinished.self)
        
        pipes.forEach { $0.removeAllActions() }
        
        run(hitSound)
    }
    
    func increaseScore(node: SKNode?) {
        guard
            let pipe = node?.parent as? PipeNode,
            let state = gameState.currentState as? GameStateRunning
        else {
            return
        }
        
        state.updateScore()
        
        score.updateText(score: state.score)
        
        pipe.removeHoleNode()
        
        run(pointSound)
    }
    
    func positionScoreNode() {
        score.position = CGPoint(
            x: center.x,
            y: size.height - safeAreaInsets.top - score.height * 0.5
        )
    }
}
