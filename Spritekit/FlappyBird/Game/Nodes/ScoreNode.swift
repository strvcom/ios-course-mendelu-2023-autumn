//
//  ScoreNode.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 13.11.2023.
//

import SpriteKit

final class ScoreNode: SKLabelNode {
    // MARK: Properties
    let height: CGFloat = 48
    
    // MARK: Init
    override init() {
        super.init()
        
        zPosition = Layer.score
        
        updateText(score: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public API
extension ScoreNode {
    func updateText(score: Int) {
        attributedText = NSAttributedString(
            string: "\(score)",
            attributes: [
                NSAttributedString.Key.strokeColor: UIColor.black,
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.strokeWidth: -2.0,
                NSAttributedString.Key.font: UIFont(
                    name: Assets.Fonts.flappy,
                    size: height
                ) as Any
            ]
        )
    }
}
