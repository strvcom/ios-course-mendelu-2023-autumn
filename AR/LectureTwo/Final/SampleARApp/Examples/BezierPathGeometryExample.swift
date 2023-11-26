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
    
    private var customNode: SCNNode?
    private(set) var lastPannedLocationZAxis: CGFloat?
    private(set) var lastPanLocation: simd_float3?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showCustomBezierPathGeometry()
        setupGestureRecognizer()
    }
}

// MARK: - Gestures
private extension BezierPathGeometryExample {
    func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture))

        sceneView.addGestureRecognizer(tapGesture)
        sceneView.addGestureRecognizer(panGesture)
        sceneView.addGestureRecognizer(pinchGesture)
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: sceneView)
        
        switch gesture.state {
        case .began:
            guard let result = sceneView.hitTest(location).first else {
                return
            }

            let worldCoordinates = result.worldCoordinates
            lastPanLocation = simd_float3(worldCoordinates)

            // Save the depth so that we do not change the depth of the bounding box when panning.
            lastPannedLocationZAxis = CGFloat(sceneView.projectPoint(worldCoordinates).z)
        case .changed:
            
            guard let lastPanLocation, let customNode else {
                return
            }
            
            let worldPosition = simd_float3(sceneView.unprojectPoint(
                SCNVector3(location.x, location.y, lastPannedLocationZAxis ?? 0)
            ))
            
            // The translation vector is the difference between the current position in world coordinates
            // and the position where we started the panning.
            let translation = worldPosition - lastPanLocation
            customNode.simdLocalTranslate(by: translation)
            
            self.lastPanLocation = worldPosition
             
        default:
            lastPanLocation = nil
            lastPannedLocationZAxis = nil
        }
    }
    
    @objc func handlePinchGesture(_ gesture: UIPinchGestureRecognizer)  {
        guard
            gesture.state == .changed
        else {
            return
        }

        customNode?.scale = SCNVector3(gesture.scale, gesture.scale, gesture.scale)
    }
    
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: sceneView)
        
        guard
            let customNode,
            let result = sceneView.hitTest(location).first,
            result.node == customNode
        else {
            return
        }

        // Set the translation vector.
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5
        SCNTransaction.completionBlock = {
            customNode.rotation = SCNVector4Make(0, 0, 1, customNode.rotation.w + .pi/4)
        }
        SCNTransaction.commit()
    }
    
}

// MARK: - BezierPath
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
        // draw from the bottom middle of our rectangle
        let rect = CGRect(origin: .zero, size: CGSize(width: 10, height: 10))
        let bottomMid = CGPoint(x: rect.width / 2, y: rect.height)
        
        // we're ready to start with our path now
        let path = UIBezierPath()
        path.flatness = 0.0002
        
        path.move(to: bottomMid)
        path.addCurve(to: CGPoint(x: 0, y: rect.height * 0.6), controlPoint1: CGPoint(x: rect.width * 0.1, y: rect.height * 0.8), controlPoint2: CGPoint(x: 0, y: rect.height * 0.7))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height * 0.6))
        path.addCurve(to: bottomMid, controlPoint1: CGPoint(x: rect.width, y: rect.height * 0.7), controlPoint2: CGPoint(x: rect.width * 0.9, y: rect.height * 0.8))
        
        path.apply(.init(scaleX: 0.05, y: 0.05).rotated(by: .pi))
        
        return path
    }
}
