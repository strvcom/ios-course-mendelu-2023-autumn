//
//  PlaneDetectionExample.swift
//  SampleARApp
//
//  Created by Tony Ngo on 06.09.2022.
//

import Foundation
import ARKit

final class PlaneDetectionExample: ARViewController {
    private var isDetecting: Bool = false

    private lazy var detectButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 50
        button.clipsToBounds = true
        button.backgroundColor = .red.withAlphaComponent(0.7)
        return button
    }()

    override func viewDidLoad() {
        setupPlaneDetection()
        super.viewDidLoad()
        setupDetectButton()
        setupTapGesture()
    }
}

// MARK: - ARSCNViewDelegate

extension PlaneDetectionExample: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Create a mesh to visualize the estimated shape of the plane.
        guard
            let planeAnchor = anchor as? ARPlaneAnchor,
            let device = sceneView.device,
            let planeGeometry = ARSCNPlaneGeometry(device: device)
        else {
            fatalError()
        }

        // Create a node to visualize the plane's bounding rectangle.
        let planeNode = SCNNode(geometry: planeGeometry)
        planeNode.opacity = 0.7
        planeNode.name = "Plane"

        let color: UIColor = planeAnchor.alignment == .horizontal ? .blue : .green
        planeNode.geometry?.firstMaterial?.diffuse.contents = color

        node.addChildNode(planeNode)

        planeGeometry.update(from: planeAnchor.geometry)
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard
            let planeAnchor = anchor as? ARPlaneAnchor,
            let planeNode = node.childNode(withName: "Plane", recursively: false),
            let planeGeometry = planeNode.geometry as? ARSCNPlaneGeometry
        else {
            return
        }

        // Update ARSCNPlaneGeometry to the anchor's new estimated shape.
        planeGeometry.update(from: planeAnchor.geometry)
    }
}

private extension PlaneDetectionExample {
    func setupPlaneDetection() {
        // 1. Create configuration that supports plane detection
        configuration = ARWorldTrackingConfiguration()

        // 2. Assign scene view's delegate to self to respond to renderer's actions
        sceneView.delegate = self

        // 3. Optionally show feature points
        sceneView.debugOptions = [.showFeaturePoints]
    }

    func setupDetectButton() {
        detectButton.addTarget(self, action: #selector(togglePlaneDetection), for: .touchUpInside)
        view.addSubview(detectButton)
        detectButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detectButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            detectButton.widthAnchor.constraint(equalToConstant: 100),
            detectButton.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        sceneView.addGestureRecognizer(tapGesture)
    }

    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: sceneView)

        guard
            let query = sceneView.raycastQuery(from: location, allowing: .estimatedPlane, alignment: .horizontal),
            let result = sceneView.session.raycast(query).first
        else {
            return
        }

        let box = makeBoxNode()
        box.simdWorldTransform = result.worldTransform
        box.simdWorldPosition.y += 0.05
        scene.rootNode.addChildNode(box)
    }

    func makeBoxNode() -> SCNNode {
        let boxGeometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        return SCNNode(geometry: boxGeometry)
    }

    @objc func togglePlaneDetection() {
        // Reset the session when turning the detection on
        let options: ARSession.RunOptions = isDetecting ? [] : [.removeExistingAnchors, .resetSceneReconstruction, .resetTracking]

        isDetecting.toggle()

        // Create new configuration for new detecting state
        let newConfiguration = ARWorldTrackingConfiguration()
        newConfiguration.planeDetection = isDetecting ? [.horizontal, .vertical] : []

        self.configuration = newConfiguration
        session.run(newConfiguration, options: options)

        let impact = UIImpactFeedbackGenerator(style: .heavy)
        impact.impactOccurred()
    }
}
