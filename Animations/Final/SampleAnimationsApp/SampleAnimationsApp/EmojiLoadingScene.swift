//
//  EmojiLoadingScene.swift
//  SampleAnimationsApp
//
//  Created by Matej Molnár on 14.11.2023.
//

import SpriteKit
import SwiftUI

class EmojiLoadingScene: SKScene {
    private let imageNames = Emojis.allCases.map { $0.rawValue }

    /// This method is called once the scene is added to a view and it is a good place to do all the setup.
    override func didMove(to view: SKView) {
        backgroundColor = .clear

        setupEmojis()
        startAnimation()
    }

    private func setupEmojis() {
        /// The size is relational, it means that the full width and height of the scene is 1.
        /// Hence we are going to be working with fractions.
        let imageWidth = 1 / CGFloat(imageNames.count)

        for (index, name) in imageNames.enumerated() {
            let node = SKSpriteNode(imageNamed: name)

            node.size = CGSize(width: imageWidth, height: imageWidth)
            node.position.y = 0.5
            /// We have to manually calculate the x position based on index.
            node.position.x = imageWidth * (CGFloat(index) + 0.5)

            addChild(node)
        }
    }

    private func startAnimation() {
        for (index, node) in children.enumerated() {
            node.run(
                .sequence([
                    /// Because of this wait actions each node starts animating 0.2 seconds after the previous one.
                    .wait(forDuration: Double(index) * 0.2),
                    /// The animation is repeating.
                    .repeatForever(
                        /// Actions in a sequence are executed one after another.
                        .sequence([
                            /// Actions in a group are executed simultaneously.
                            .group([
                                /// Rotate the node 360 degrees.
                                .rotate(byAngle: .pi * 2, duration: 0.6),
                                /// Scale the node by 50% and then back.
                                .sequence([
                                    .scale(to: 1.5, duration: 0.3),
                                    .scale(to: 1, duration: 0.3)
                                ])
                            ]),
                            /// After the rotation + scale animation is done wait for 0.6 before repeating it, otherwise the animation would look chaotic.
                            .wait(forDuration: 0.6)
                        ])
                    )
                ])
            )
        }
    }
}

#Preview {
    SpriteView(
        scene: EmojiLoadingScene(),
        options: [.allowsTransparency]
    )
    .frame(width: 300, height: 300)
}
