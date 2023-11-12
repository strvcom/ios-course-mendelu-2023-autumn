//
//  GameScene.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 12.11.2023.
//

import SpriteKit
import SwiftUI
import AVFoundation

final class GameScene: SKScene {
    // MARK: Properties
    private let bird = Bird()
    private let base = Base()
    private var pipes = [Pipe]()
    
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
    
    // MARK: Overrides
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        
        scaleMode = .aspectFill
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        addChild(Background())
        
        addChild(base)
        
        addChild(bird)
        
        bird.position = CGPoint(
            x: size.width * 0.3,
            y: sceneCenterY
        )
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(
            dx: 0,
            dy: -5
        )
        
        createTopBoundary()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("AVAudioSession setup error \(error)")
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        bird.updateRotation()
        
        updatePipes()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        bird.flapWings()
    }
}

// MARK: SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let contactBody = if contact.bodyA.node?.name == NodeName.bird {
            contact.bodyB
        } else {
            contact.bodyA
        }
        
        switch contactBody.node?.name {
        case NodeName.pipe, NodeName.base:
//            run(
//                SKAction.playSoundFileNamed(
//                    Assets.Sounds.hit,
//                    waitForCompletion: false
//                )
//            )
            break
        case NodeName.pipeHole:
            run(pointSound)
        default:
            break
        }
    }
}

// MARK: Private API
private extension GameScene {
    func createTopBoundary() {
        let node = SKNode()
        node.position = CGPoint(
            x: 0,
            y: size.height
        )
        node.physicsBody = SKPhysicsBody(
            rectangleOf: CGSize(
                width: size.width,
                height: 1
            )
        )
        node.physicsBody?.isDynamic = false
        node.physicsBody?.friction = 0
        node.physicsBody?.restitution = 0
        node.physicsBody?.categoryBitMask = Physics.CategoryBitMask.sceneBorder
        node.physicsBody?.collisionBitMask = Physics.CollisionBitMask.sceneBorder
        
        addChild(node)
    }
    
    func updatePipes() {
        guard !pipes.isEmpty else {
            return spawnPipe()
        }
        
        // Move all pipes to left
        pipes.forEach { $0.position.x -= 1.5 }
        
        // Remove all pipes on left
        pipes.filter { $0.scenePosition == .onLeft }
            .forEach { removePipe($0) }
        
        // Spawn pipe if needed
        if let pipe = pipes.last {
            let distanceBetweenPipes: CGFloat = bird.size.width * 4
            
            if pipe.position.x + distanceBetweenPipes < size.width + 26 {
                spawnPipe()
            }
        }
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
        
        let pipe = Pipe(holeHeight: holeHeight)
        pipe.position = CGPoint(
            x: size.width + pipe.width * 0.5,
            y: pipeYPosition
        )
        
        pipes.append(pipe)
        
        addChild(pipe)
    }
    
    func removePipe(_ pipe: Pipe) {
        pipes.removeAll(where: { $0 === pipe })
        
        pipe.removeFromParent()
    }
}
