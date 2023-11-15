//
//  GestureManager.swift
//  DimensionsAR
//
//  Created by Tony Ngo on 06.10.2022.
//

import ARKit
import Combine

final class GestureManager {
    // MARK: - Public Properties

    var dimensionsPublisher: AnyPublisher<BoundingBox.Dimensions, Never> {
        dimensionsSubject.eraseToAnyPublisher()
    }

    var isGestureEnabled: Bool = false

    // MARK: - Private Properties

    private var isBoundingBoxInHierarchy: Bool {
        boundingBox.parent != nil
    }

    private(set) lazy var boundingBox: BoundingBox = BoundingBox()

    private(set) var lastPannedLocationZAxis: CGFloat?
    private(set) var lastPanLocation: simd_float3?
    private(set) var currentDraggedFace: FaceDrag?
    private var sceneView: ARSCNView = ARSCNView()
    private let dimensionsSubject: PassthroughSubject<BoundingBox.Dimensions, Never> = .init()
}

// MARK: - Public Methods

extension GestureManager {
    func setupGestures(in view: ARSCNView) {
        sceneView = view
        setupGestures()
    }
}

// MARK: - Private Methods

private extension GestureManager {
    func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture))
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))

        [tapGesture, panGesture, pinchGesture, longPressGesture]
            .forEach(sceneView.addGestureRecognizer)
    }

    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: sceneView)
        
        guard
            isGestureEnabled,
            isBoundingBoxInHierarchy == false,
            let query = sceneView.raycastQuery(from: location, allowing: .estimatedPlane, alignment: .horizontal),
            let result = sceneView.session.raycast(query).first
        else {
            return
        }

        // Set the bounding box's translation vector.
        boundingBox.simdWorldPosition = simd_float3(result.worldTransform.columns.3)
        boundingBox.simdWorldPosition.y += boundingBox.extent.y / 2

        sceneView.scene.rootNode.addChildNode(boundingBox)
        dimensionsSubject.send(boundingBox.dimensions)
    }
}

// MARK: - Pan Gesture

private extension GestureManager {
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard isGestureEnabled, isBoundingBoxInHierarchy else {
            return
        }

        let location = gesture.location(in: sceneView)

        switch gesture.state {
        case .began:
            guard let result = sceneView.hitTest(location).first else {
                return
            }

            let worldCoordinates = result.worldCoordinates
            lastPanLocation = simd_float3(worldCoordinates)

            // Save the depth so that we do not change the depth of the bounding box when panning.
            lastPannedLocationZAxis = CGFloat(sceneView.projectPoint(worldCoordinates).z)
        case .changed:
            // 1. Option
            /*
            guard let lastPanLocation = lastPanLocation else {
                return
            }

            let worldPosition = simd_float3(sceneView.unprojectPoint(
                SCNVector3(location.x, location.y, lastPannedLocationZAxis ?? 0)
            ))

            // The translation vector is the difference between the current position in world coordinates
            // and the position where we started the panning.
//            let translation = worldPosition - lastPanLocation
//            boundingBox.simdLocalTranslate(by: translation)

            self.lastPanLocation = worldPosition
             */

            // 2. Option - Move only on the plane, up and down panning moves on the z-axis rather than on the y-axis.
            guard
                let query = sceneView.raycastQuery(from: location, allowing: .estimatedPlane, alignment: .horizontal),
                let result = sceneView.session.raycast(query).first
            else {
                return
            }

            
            boundingBox.simdWorldPosition = simd_float3(result.worldTransform.columns.3)
            boundingBox.simdWorldPosition.y += boundingBox.extent.y / 2
        default:
            lastPanLocation = nil
            lastPannedLocationZAxis = nil
        }
    }
}

// MARK: - Pinch Gesture

private extension GestureManager {
    @objc func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        guard
            isGestureEnabled,
            isBoundingBoxInHierarchy,
            gesture.state == .changed
        else {
            return
        }

        boundingBox.extent *= Float(gesture.scale)

        // To reset the velocity.
        gesture.scale = 1

        dimensionsSubject.send(boundingBox.dimensions)
    }
}

// MARK: - Long Press Gesture

private extension GestureManager {
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        guard isGestureEnabled, isBoundingBoxInHierarchy else {
            return
        }

        let location = gesture.location(in: sceneView)

        switch gesture.state {
        case .began:
            guard let camera = sceneView.pointOfView else {
                return
            }

            for result in sceneView.hitTest(location, options: [.rootNode: boundingBox.facesNode]) {
                if let face = result.node as? BoundingBoxFace {
                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                    generator.impactOccurred()

                    // Normalized normal vector in scene's world coordinates.
                    let faceNormalInWorld = normalize(boundingBox.simdConvertVector(face.normal, to: nil))

                    let ray = Ray(origin: SIMD3<Float>(result.worldCoordinates), direction: faceNormalInWorld)
                    let transform = dragPlaneTransform(for: ray, cameraPos: camera.simdWorldPosition)

                    currentDraggedFace = FaceDrag(
                        face: face,
                        planeTransform: transform,
                        beginWorldPos: boundingBox.simdWorldPosition,
                        beginExtent: boundingBox.extent
                    )
                }

                dimensionsSubject.send(boundingBox.dimensions)
            }
        case .changed:
            guard
                let currentDraggedFace = currentDraggedFace,
                let hitPos = sceneView.unprojectPointLocal(location, ontoPlane: currentDraggedFace.planeTransform)
            else {
                return
            }

            // Compute a new position for this side of the bounding box based on the given screen position.
            // In the face's local coordinate system we are interested in the x-axis movement.
            let movementAlongRay = hitPos.x

            // Take the currently dragged face's normal vector and multiply it by the ray movement direction
            // so that we are changing only the extent of the dragged face.
            // (try removing the lhs of the multiplication)
            let extentOffset = currentDraggedFace.normal * movementAlongRay

            // Calculate new extent by adding the offset.
            let newExtent = currentDraggedFace.beginExtent + extentOffset

            let minSize = boundingBox.minSize
            guard newExtent.x >= minSize && newExtent.y >= minSize && newExtent.z >= minSize else {
                return
            }

            // First column of the planeTransform is the ray along which the box
            // is manipulated, in world coordinates. The center of the bounding box
            // has to be moved by half of the finger's movement on that ray.
            let originOffset = (currentDraggedFace.planeTransform.columns.0 * (movementAlongRay / 2)).xyz

            // Push/pull a single side of the bounding box by a combination
            // of moving & changing the extent of the box.
            currentDraggedFace.face.geometry?.firstMaterial?.diffuse.contents = UIColor.green
            boundingBox.simdWorldPosition = currentDraggedFace.beginWorldPos + originOffset
            boundingBox.extent = newExtent
            dimensionsSubject.send(boundingBox.dimensions)
        case .failed, .cancelled, .ended:
            currentDraggedFace = nil
        case .possible:
            break
        @unknown default:
            break
        }
    }

    func dragPlaneTransform(for dragRay: Ray, cameraPos: SIMD3<Float>) -> float4x4 {
        let normalizedCameraToRayOrigin = normalize(dragRay.origin - cameraPos)
        let xVector = dragRay.direction
        let zVector = normalize(cross(xVector, normalizedCameraToRayOrigin))
        let yVector = normalize(cross(xVector, zVector))

        return float4x4([
            SIMD4<Float>(xVector, 0),
            SIMD4<Float>(yVector, 0),
            SIMD4<Float>(zVector, 0),
            SIMD4<Float>(dragRay.origin, 1)
        ])
    }
}
