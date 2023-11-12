//
//  Assets.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 12.11.2023.
//

import SpriteKit

enum Assets {}

// MARK: Textures
extension Assets {
    static let background = SKSpriteNode(imageNamed: "background")
    static let pipe = SKSpriteNode(imageNamed: "pipe")
    static let base = SKSpriteNode(imageNamed: "base")
    static let bird = SKTextureAtlas(named: "bird")
}

// MARK: Sounds
extension Assets {
    static let die = "die.waw"
    static let hit = "hit.waw"
    static let point = "point.waw"
    static let swoosh = "swoosh.waw"
    static let wing = "wing.waw"
}
