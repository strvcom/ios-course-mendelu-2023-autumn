//
//  Score.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 13.11.2023.
//

import SpriteKit

final class Score: SKLabelNode {
    // MARK: Properties
    var score = 0 {
        didSet {
            updateText()
        }
    }
    
    override init() {
        super.init()
        
        zPosition = Layer.score
        
        updateText()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private API
private extension Score {
    func updateText() {
        attributedText = NSAttributedString(
            string: "\(score)",
            attributes: [
                NSAttributedString.Key.strokeColor: UIColor.black,
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.strokeWidth: -2.0,
                NSAttributedString.Key.font: UIFont(
                    name: Assets.Fonts.flappy,
                    size: 48
                ) as Any
            ]
        )
    }
}
