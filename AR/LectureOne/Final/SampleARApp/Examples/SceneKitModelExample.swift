//
//  CustomSceneExample.swift
//  SampleARApp
//
//  Created by Tony Ngo on 14.10.2022.
//

import Foundation
import ARKit

final class SceneKitModelExample: ARViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initSceneKitModel()
    }
}

private extension SceneKitModelExample {
    func initSceneKitModel() {
        // The initialization can fail if the scene file does not exist.
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        sceneView.scene = scene
    }
}
