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
    func createUIFromModel() {
        // TODO: 3
        // load RC model
    }
    
    func createUIProgrammatically() {
        // TODO: 4
        // create rc model programmatically
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
