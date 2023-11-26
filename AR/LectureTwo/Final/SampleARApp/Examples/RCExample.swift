//
//  RCExample.swift
//  SampleARApp
//
//  Created by Tomas Cejka on 06.11.2023.
//

import RealityKit
import UIKit

final class RCExample: UIViewController {
    
    let sceneView = ARView()
    
    override func viewDidLoad() {
        initialSetup()
        super.viewDidLoad()
        
        createUIProgrammatically()
        createUIFromModel()
    }
}

// MARK: - Setup RC model
private extension RCExample {
    func createUIProgrammatically() {
        let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
        let material = SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: true)
        let model = ModelEntity(mesh: mesh, materials: [material])

        // Create horizontal plane anchor for the content
        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
        anchor.children.append(model)

        // Add the horizontal plane anchor to the scene
        sceneView.scene.addAnchor(anchor)
    }
    
    func createUIFromModel() {
        let sceneAnchor = try! Experience.loadScene()
        sceneView.scene.addAnchor(sceneAnchor)
    }
}


private extension RCExample {
    func initialSetup() {

        view.addSubview(sceneView)
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
