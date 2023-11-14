//
//  VisionExample.swift
//  SampleARApp
//
//  Created by Tony Ngo on 07.09.2022.
//

import ARKit
import Foundation
import Vision

final class VisionHandExample: ARViewController {

    private let visionQueue = DispatchQueue(label: "com.strv.mendelu.SampleARApp.visionQueue")

    private let minimumConfidence: Float = 0.3

    private let pointPath = UIBezierPath()

    private lazy var coordinatesAdapter = CoordinatesAdapter(screenSize: sceneView.bounds.size)

    private lazy var overlayLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = sceneView.frame
        return layer
    }()

    private let indexTipPoint: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()

    override func viewDidLoad() {
        setupVision()
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - ARSessionDelegate

extension VisionHandExample: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let capturedImage = frame.capturedImage

        // TODO: 14
        // detect hand by vision

    }
}

private extension VisionHandExample {
    func setupView() {
        overlayLayer.fillColor = UIColor.green.cgColor
        view.layer.addSublayer(overlayLayer)
    }

    func setupVision() {
        session.delegate = self
    }

    func showIndexFingerPoint(_ point: CGPoint) {
        let screenPoint = coordinatesAdapter.screenCoordinates(normalizedImagePoint: point)

        pointPath.removeAllPoints()
        pointPath.move(to: screenPoint)
        pointPath.addArc(
            withCenter: screenPoint,
            radius: 5,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: true
        )

        overlayLayer.path = pointPath.cgPath
    }
}
