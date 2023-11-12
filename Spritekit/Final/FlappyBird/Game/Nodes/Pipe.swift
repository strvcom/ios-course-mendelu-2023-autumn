//
//  Pipe.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 12.11.2023.
//

import SpriteKit

final class Pipe: SKNode {
    // MARK: Properties
    private let holeHeight: CGFloat
    
    let width: CGFloat
    
    var scenePosition: ScenePosition {
        guard let scene = parent as? SKScene else {
            return .none
        }
        
        let isOnRight = position.x - width * 0.5 >= scene.size.width
        
        let isOnLeft = position.x + width * 0.5 <= 0
        
        if isOnRight {
            return .onRight
        } else if isOnLeft {
            return .onLeft
        } else {
            return .visible
        }
    }
    
    // MARK: Init
    init(holeHeight: CGFloat) {
        self.holeHeight = holeHeight
        
        let pipeTexture = SKTexture(imageNamed: Assets.Textures.pipe)
        
        let pipeTextureSize = pipeTexture.size()
        
        self.width = pipeTextureSize.width
        
        super.init()
        
        zPosition = Layer.pipe
        
        createUpPipe(texture: pipeTexture)
        
        createDownPipe(texture: pipeTexture)
        
        createHole()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Scene position
extension Pipe {
    enum ScenePosition {
        case onRight
        case visible
        case onLeft
        case none
    }
}

// MARK: Private API
private extension Pipe {
    func createPipe(texture: SKTexture) -> SKSpriteNode {
        let pipe = SKSpriteNode(texture: texture)
        pipe.name = NodeName.pipe
        pipe.physicsBody = SKPhysicsBody(
            texture: texture,
            size: pipe.size
        )
        pipe.physicsBody?.isDynamic = false
        return pipe
    }
    
    func createUpPipe(texture: SKTexture) {
        let pipe = createPipe(texture: texture)
        pipe.zRotation = .pi
        pipe.position = CGPoint(
            x: 0,
            y: pipe.size.height * 0.5 + holeHeight * 0.5
        )
        
        addChild(pipe)
    }
    
    func createDownPipe(texture: SKTexture) {
        let pipe = createPipe(texture: texture)
        pipe.position = CGPoint(
            x: 0,
            y: -pipe.size.height * 0.5 - holeHeight * 0.5
        )
        
        addChild(pipe)
    }
    
    func createHole() {
        let holeNode = SKNode()
        holeNode.name = NodeName.pipeHole
        holeNode.physicsBody = SKPhysicsBody(
            rectangleOf: CGSize(
                width: 1,
                height: holeHeight
            )
        )
        holeNode.physicsBody?.categoryBitMask = Physics.CategoryBitMask.hole
        holeNode.physicsBody?.collisionBitMask = 0
        holeNode.physicsBody?.contactTestBitMask = Physics.ContactTestBitMask.hole
        holeNode.physicsBody?.isDynamic = false
        
        addChild(holeNode)
    }
}
