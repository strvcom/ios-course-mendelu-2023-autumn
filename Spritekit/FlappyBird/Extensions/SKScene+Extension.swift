//
//  SKScene+Extension.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 26.11.2023.
//

import SpriteKit

extension SKScene {
    var center: CGPoint {
        CGPoint(
            x: size.width * 0.5,
            y: size.height * 0.5
        )
    }
    
    var safeAreaInsets: UIEdgeInsets {
        view?.safeAreaInsets ?? .zero
    }
}
