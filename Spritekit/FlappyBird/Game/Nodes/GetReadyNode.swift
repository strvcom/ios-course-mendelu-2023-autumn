//
//  GetReadyNode.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 14.11.2023.
//

import SpriteKit

final class GetReadyNode: SKSpriteNode {
    // MARK: Init
    init() {
        let texture = SKTexture(imageNamed: Assets.Textures.getReady)
        
        super.init(
            texture: texture,
            color: .clear,
            size: texture.size()
        )
        
        zPosition = Layer.getReady
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
