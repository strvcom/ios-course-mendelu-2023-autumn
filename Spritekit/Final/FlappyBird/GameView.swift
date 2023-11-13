//
//  ContentView.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 12.11.2023.
//

import SwiftUI
import SpriteKit

struct GameView {
    // MARK: Properties
    @State private var scene = GameScene(size: Background().size)
}

// MARK: View
extension GameView: View {
    var body: some View {
        SpriteView(
            scene: scene,
            preferredFramesPerSecond: 30,
            debugOptions: [
                .showsFPS,
                .showsPhysics,
                .showsNodeCount
            ]
        )
        .ignoresSafeArea()
    }
}
