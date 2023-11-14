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
    
    private lazy var bird = BirdNode()
    private lazy var base = BaseNode()
    private lazy var score = ScoreNode()
    private var pipes = [PipeNode]()
    
    private let pointSound = SKAction.playSoundFileNamed(
        Assets.Sounds.point,
        waitForCompletion: false
    )
    
    private let hitSound = SKAction.playSoundFileNamed(
        Assets.Sounds.hit,
        waitForCompletion: false
    )
    
    private var sceneCenterY: CGFloat {
        size.height * 0.5
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
        
        addChild(BackgroundNode())
        addChild(base)
        addChild(bird)
        addChild(score)
        
        let topBoundaryNode = TopBoundaryNode(width: size.width)
        topBoundaryNode.position = CGPoint(
            x: 0,
            y: size.height
        )
        
        addChild(topBoundaryNode)
        
        score.position = CGPoint(
            x: size.width * 0.5,
            y: size.height - 75
        )
        
        bird.position = CGPoint(
            x: size.width * 0.3,
            y: sceneCenterY + base.size.height
        )
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(
            dx: 0,
            dy: -5
        )
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("AVAudioSession setup error \(error)")
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        guard gameState.currentState is GameStateRunning else {
            return
        }
        
        bird.updateRotation()
        
        updatePipes()
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
            run(hitSound)
            
            gameState.enter(GameStateFinished.self)
        case NodeName.pipeHole:
            increaseScore(node: contactBody.node)
        default:
            break
        }
    }
}

// MARK: Private API
private extension GameScene {
    func updatePipes() {
        guard !pipes.isEmpty else {
            return spawnPipe()
        }
        
        movePipes()
        
        removePipesOnLeft()
        
        spawnPipeIfNeeded()
    }
    
    func movePipes() {
        pipes.forEach { $0.position.x -= 1.5 }
    }
    
    func removePipesOnLeft() {
        pipes.filter { $0.scenePosition == .onLeft }
            .forEach { pipe in
                pipes.removeAll(where: { $0 === pipe })
                
                pipe.removeFromParent()
            }
    }
    
    func spawnPipeIfNeeded() {
        let distanceBetweenPipes: CGFloat = bird.size.width * 4
        
        guard 
            let pipe = pipes.last,
            pipe.position.x + distanceBetweenPipes < size.width + pipe.width * 0.5
        else {
            return
        }
        
        spawnPipe()
    }
    
    func spawnPipe() {
        let holeHeight = bird.size.height * 4
        
        let lastPipeYPosition = (pipes.last?.position.y ?? sceneCenterY)
        
        let randomOffset = CGFloat.random(in: -150 ... 150)
        
        let topYOffsetTreshold = size.height - holeHeight * 0.5
        
        let bottomYOffsetTreshold = base.position.y + base.size.height + holeHeight * 0.5
        
        var pipeYPosition = lastPipeYPosition + randomOffset
        if pipeYPosition > topYOffsetTreshold
            || pipeYPosition < bottomYOffsetTreshold {
            pipeYPosition = lastPipeYPosition - randomOffset
        }
        
        let pipe = PipeNode(holeHeight: holeHeight)
        pipe.position = CGPoint(
            x: size.width + pipe.width * 0.5,
            y: pipeYPosition
        )
        
        pipes.append(pipe)
        
        addChild(pipe)
    }
    
    func increaseScore(node: SKNode?) {
        guard 
            let pipe = node?.parent as? PipeNode,
            !pipe.scoreCounted
        else {
            return
        }
        
        pipe.scoreCounted = true
        
        score.score += 1
        
        run(pointSound)
    }
}
