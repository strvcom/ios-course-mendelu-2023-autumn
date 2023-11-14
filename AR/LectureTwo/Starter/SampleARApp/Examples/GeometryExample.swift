//
//  GeometryExample.swift
//  SampleARApp
//
//  Created by Tony Ngo on 02.09.2022.
//

import Foundation
import SceneKit
import SpriteKit

final class GeometryExample: ARViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        showCustomNode()
    }
}

private extension GeometryExample {
    func showCustomNode() {
        let width: Float = 0.15
        let height: Float = 0.3

        // 1. Define vertices
        let vertices: [SCNVector3] = [
            SCNVector3(0, height, 0),       // 0
            SCNVector3(-width, 0, width),   // 1
            SCNVector3(width, 0, width),    // 2
            SCNVector3(width, 0, -width),   // 3
            SCNVector3(-width, 0, -width),  // 4
            SCNVector3(0, -height, 0),      // 5
        ]

        // 2. Define indices
        let indices: [Int32] = [
            // TODO: 11
            // set indices
        ]

        let colors: [SCNVector3] = [
            SCNVector3(0.846, 0.035, 0.708), // magenta
            SCNVector3(0.001, 1.000, 0.603), // cyan
            SCNVector3(0.006, 0.023, 0.846), // blue
        ]

        let colorsMapped = indices.map { colors[Int($0) % 3] }

        // TODO: 12
        // Create a geometry
        
        // Create a node
        
        // Move the node 1m in front of us and keep rotating it
        
        
        // TODO: 13
        // add animation
    }
}
