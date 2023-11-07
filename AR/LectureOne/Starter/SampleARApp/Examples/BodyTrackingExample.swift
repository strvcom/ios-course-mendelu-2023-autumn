//
//  BodyTrackingExample.swift.swift
//  SampleARApp
//
//  Created by Tony Ngo on 11.10.2022.
//

import Foundation
import ARKit

final class BodyTrackingExample: ARViewController {
    override func viewDidLoad() {
        setupBodyTracking()
        super.viewDidLoad()
    }
}

// MARK: - ARSessionDelegate

extension BodyTrackingExample: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        // Iterate over all anchors added to the scene.
        for anchor in anchors {
            // Access only body anchors.
            guard let bodyAnchor = anchor as? ARBodyAnchor else {
                continue
            }

            // TODO: 9
            // detect body
            
            // The body anchor's position is the root for all other anchors on the skeleton.
            // All other body parts' positions are relative to the root anchor.
            
            // To get a body part's position we need to add its translation vector to the root vector.
            
            // Check which hand is above head and show a sphere.
            // Note that the head's position (or its pivot) is not at the top of the head but rather somewhere in the middle.
        }
    }
}

private extension BodyTrackingExample {
    func setupBodyTracking() {
        guard ARBodyTrackingConfiguration.isSupported else {
            fatalError("This feature is only supported on devices with an A12 chip")
        }

        // TODO: 8
        // setup body tracking configuration
    }

    func addNodeOrMove(to position: simd_float3) {
        if scene.rootNode.childNodes.isEmpty {
            let box = SCNSphere(radius: 0.2)
            box.firstMaterial?.diffuse.contents = UIColor.red

            let node = SCNNode(geometry: box)
            node.simdWorldPosition = position

            scene.rootNode.addChildNode(node)
        } else if let childNode = scene.rootNode.childNodes.first {
            childNode.simdWorldPosition = position
        }
    }
}
