//
//  Layer.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 12.11.2023.
//

import CoreGraphics

/// Definition of the Z position of the objects, which means depth of the objects in scene.
/// `SKNodes` with higher value are going to overlap the nodes with smaller one.
enum Layer {
    static let background: CGFloat = 0
    static let pipe: CGFloat = 1
    // Some of the objects can have the same value, because they won't overlap
    // due to having physics body (they will colide).
    static let base: CGFloat = 2
    static let bird: CGFloat = 2
    static let score: CGFloat = 3
    static let getReady: CGFloat = 3
}
