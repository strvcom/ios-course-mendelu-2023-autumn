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

        // The captured image is in horizontal orientation so we need to switch the height and width.
        coordinatesAdapter.imageSize = .init(width: capturedImage.height, height: capturedImage.width)

        // 1. Create a request
        let request = VNDetectHumanHandPoseRequest()
        request.maximumHandCount = 1

        // 2. Create request handler responsible for image analysis
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: capturedImage, orientation: .right)

        visionQueue.async { [weak self] in
            guard let self = self else {
                return
            }

            do {
                // 3. Perform request
                try requestHandler.perform([request])

                // 4. Access request's results - observations
                let observations = request.results ?? []

                // 5. Iterate through observations and access wanted recognized points.
                for observation in observations {
                    let indexTip = try observation.recognizedPoint(.indexTip)

                    // 6. Only accept points with confidence (precision) higher than the minimum.
                    guard indexTip.confidence >= self.minimumConfidence else {
                        return
                    }

                    // 7. Show the recognized point as a simple 2D point on screen.
                    DispatchQueue.main.async { [weak self] in
                        // The vision's origin is at the lower-left corner.
                        // We want to convert to UIKit's coordinate system, which is at the top-left corner.
                        self?.showIndexFingerPoint(CGPoint(x: indexTip.x, y: 1 - indexTip.y))
                    }
                }
            } catch {
                print("An error occurred performing Vision request:", error)
            }
        }
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
