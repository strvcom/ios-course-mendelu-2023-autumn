//
//  PipeNode.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 12.11.2023.
//

import SpriteKit

final class PipeNode: SKNode {
    // MARK: Properties
    private let holeHeight: CGFloat
    
    let width: CGFloat
    
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

// MARK: Public API
extension PipeNode {
    func removeHoleNode() {
        guard let holeNode = children.first(where: { $0.name == NodeName.pipeHole }) else {
            return
        }
        
        holeNode.removeFromParent()
    }
}

// MARK: Private API
private extension PipeNode {
    func createPipe(texture: SKTexture) -> SKSpriteNode {
        let pipe = SKSpriteNode(texture: texture)
        pipe.name = NodeName.pipe
        pipe.physicsBody = SKPhysicsBody(
            texture: texture,
            size: pipe.size
        )
        pipe.physicsBody?.categoryBitMask = Physics.CategoryBitMask.pipe
        pipe.physicsBody?.collisionBitMask = Physics.CollisionBitMask.pipe
        pipe.physicsBody?.contactTestBitMask = Physics.ContactTestBitMask.pipe
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
        // Setting collisionbitmask to 0 means no collision with this physics body will happen.
        holeNode.physicsBody?.collisionBitMask = 0
        holeNode.physicsBody?.contactTestBitMask = Physics.ContactTestBitMask.hole
        holeNode.physicsBody?.isDynamic = false
        
        addChild(holeNode)
    }
}
