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
            0, 1, 2,
            2, 3, 0,
            3, 4, 0,
            4, 1, 0,

            1, 5, 2,
            2, 5, 3,
            3, 5, 4,
            4, 5, 1
        ]

        let colors: [SCNVector3] = [
            SCNVector3(0.846, 0.035, 0.708), // magenta
            SCNVector3(0.001, 1.000, 0.603), // cyan
            SCNVector3(0.006, 0.023, 0.846), // blue
        ]

        let colorsMapped = indices.map { colors[Int($0) % 3] }

        // 3. Create a geometry
        let colorsSource = SCNGeometrySource(colors: colorsMapped)
        let verticesSource = SCNGeometrySource(vertices: vertices)
        let indicesElement = SCNGeometryElement(indices: indices, primitiveType: .triangles)

        let geometry = SCNGeometry(
            sources: [verticesSource, colorsSource],
            elements: [indicesElement]
        )

        // 4. Create a node
        let customNode = SCNNode(geometry: geometry)

        // 5. Add node to the scene
        sceneView.scene.rootNode.addChildNode(customNode)

        // Move the node 1m in front of us and keep rotating it
        customNode.localTranslate(by: SCNVector3(0, 0, -1))
        let rotation = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: .pi, z: 0, duration: 3))
        customNode.runAction(rotation)
    }
}
