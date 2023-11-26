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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Run the scene view's session
        let configuration: ARConfiguration = self.configuration ?? ARWorldTrackingConfiguration()
        session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the scene view's session
        session.pause()
    }
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
