//
//  NodeName.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 12.11.2023.
//

/// Names of nodes in scene.
///
/// When you assign `name` to `SKNode`, you can easily find it with
/// function [childNode(withName: String)](https://developer.apple.com/documentation/spritekit/sknode/1483060-childnode)
/// on `SKNode` object.
enum NodeName {
    static let pipe = "pipe"
    static let pipeHole = "pipeHole"
    static let bird = "bird"
    static let base = "base"
}
