//
//  ARViewController.swift
//  SampleARApp
//
//  Created by Tony Ngo on 02.09.2022.
//

import ARKit
import Foundation
import UIKit

class ARViewController: UIViewController {
    
    let sceneView = ARSCNView()
    var configuration: ARConfiguration?

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    // TODO: 1
    // set configuration & session
}

extension ARViewController {
    var session: ARSession {
        sceneView.session
    }

    var scene: SCNScene {
        sceneView.scene
    }
}

private extension ARViewController {
    func initialSetup() {
        // Enable lightning
        sceneView.autoenablesDefaultLighting = true

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
