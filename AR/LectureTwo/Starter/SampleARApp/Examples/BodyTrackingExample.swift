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

            let transformFor = bodyAnchor.skeleton.modelTransform
            guard
                let headTransform = transformFor(.head),
                let leftHandTransform = transformFor(.leftHand),
                let rightHandTransform = transformFor(.rightHand)
            else {
                continue
            }

            // The body anchor's position is the root for all other anchors on the skeleton.
            // All other body parts' positions are relative to the root anchor.
            let rootPosition = bodyAnchor.transform.translation

            // To get a body part's position we need to add its translation vector to the root vector.
            let headPosition = rootPosition + headTransform.translation

            let handsPosition = (
                left: rootPosition + leftHandTransform.translation,
                right: rootPosition + rightHandTransform.translation
            )

            // Check which hand is above head and show a sphere.
            // Note that the head's position (or its pivot) is not at the top of the head but rather somewhere in the middle.
            if handsPosition.left.y > headPosition.y {
                addNodeOrMove(to: handsPosition.left)
            } else if handsPosition.right.y > headPosition.y {
                addNodeOrMove(to: handsPosition.right)
            } else {
                scene.rootNode.childNodes.forEach {
                    $0.removeFromParentNode()
                }
            }
        }
    }
}

private extension BodyTrackingExample {
    func setupBodyTracking() {
        guard ARBodyTrackingConfiguration.isSupported else {
            fatalError("This feature is only supported on devices with an A12 chip")
        }

        // Set a configuration that trackings body parts.
        configuration = ARBodyTrackingConfiguration()

        session.delegate = self

        sceneView.autoenablesDefaultLighting = true
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
