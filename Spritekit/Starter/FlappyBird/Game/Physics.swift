//
//  Physics.swift
//  FlappyBird
//
//  Created by Róbert Oravec on 28.11.2023.
//

enum Physics {}

extension Physics {
    enum CategoryBitMask {
        static let base: UInt32 = 0b1
        static let bird: UInt32 = 0b10
        static let sceneBorder: UInt32 = 0b100
    }
}

extension Physics {
    enum CollisionBitMask {
        static let base = Physics.CategoryBitMask.bird
        static let bird = Physics.CategoryBitMask.base | Physics.CategoryBitMask.sceneBorder
        static let sceneBorder = Physics.CategoryBitMask.bird
    }
}
