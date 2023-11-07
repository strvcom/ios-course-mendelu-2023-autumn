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
        // Create a mesh to visualize detected plane
        // TODO: 6
        // add an SCNNode with custom plane
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
        // TODO: 5
        // setup configuration for plane detection
    }
    
    // TODO: 7
    // create a SCNode
    

    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: sceneView)

        guard
            let query = sceneView.raycastQuery(from: location, allowing: .estimatedPlane, alignment: .horizontal),
            let result = sceneView.session.raycast(query).first
        else {
            return
        }

        // TODO: 8
        // add newly created SCNod
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        sceneView.addGestureRecognizer(tapGesture)
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
