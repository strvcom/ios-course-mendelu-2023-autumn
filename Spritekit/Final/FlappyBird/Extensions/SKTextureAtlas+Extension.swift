//
//  SKTextureAtlas+Extension.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 12.11.2023.
//

import SpriteKit

extension SKTextureAtlas {
    /// Returns sorted `SKTextures` from `SKTextureAtlas`.
    var textures: [SKTexture] {
        textureNames
            .sorted()
            .map { textureNamed($0) }
    }
}
