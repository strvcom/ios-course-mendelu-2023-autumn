//
//  BezierPathGeometryExample.swift
//  SampleARApp
//
//  Created by Tony Ngo on 06.09.2022.
//

import Foundation
import SceneKit
import UIKit

final class BezierPathGeometryExample: ARViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        showCustomBezierPathGeometry()
    }
}

private extension BezierPathGeometryExample {
    func showCustomBezierPathGeometry() {
        // 1. Create UIBezierPath
        let path = makeBezierPath()

        // 2. Create a geometry
        let shapeGeometry = SCNShape(path: path, extrusionDepth: 0.2)
        shapeGeometry.firstMaterial?.diffuse.contents = UIColor.green

        // 3. Create a node
        let node = SCNNode(geometry: shapeGeometry)
        node.position = .init(x: 0, y: 0, z: -1)

        scene.rootNode.addChildNode(node)
    }

    /// Source: https://suragch.medium.com/designing-and-drawing-bézier-paths-in-ios-c886c3050ffb
    func makeBezierPath() -> UIBezierPath {
        let path = UIBezierPath()
        // starting point for the path (bottom left)
       
        
        // TODO: 10
        // play with bezier path
        
        path.close()
        path.apply(.init(scaleX: 0.05, y: 0.05))
        return path
    }
}
