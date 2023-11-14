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
    @StateObject private var game = Game()
}

// MARK: View
extension GameView: View {
    var body: some View {
        SpriteView(
            scene: game.scene,
            transition: .crossFade(withDuration: 10),
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
