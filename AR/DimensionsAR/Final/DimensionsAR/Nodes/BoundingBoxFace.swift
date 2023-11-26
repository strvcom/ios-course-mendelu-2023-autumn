//
//  BoundingBoxFace.swift
//  DimensionsAR
//
//  Created by Tony Ngo on 06.10.2022.
//

import SceneKit

final class BoundingBoxFace: SCNNode {
    // MARK: - Public Properties

    enum Face: CaseIterable {
        case front, back, left, right, bottom, top
    }

    /// The face's normal vector.
    var normal: SIMD3<Float> {
        switch face {
        case .front, .right, .top:
            return dragAxis.normal
        case .back, .left, .bottom:
            return -dragAxis.normal
        }
    }

    /// The axis about which the face is dragged.
    var dragAxis: Axis {
        switch face {
        case .left, .right:
            return .x
        case .top, .bottom:
            return .y
        case .front, .back:
            return .z
        }
    }

    // MARK: - Private Properties

    private var size: CGSize = .zero
    private let face: Face

    // MARK: - Initialization

    init(
        _ face: Face,
        boundingBoxExtent extent: SIMD3<Float>
    ) {
        self.face = face
        super.init()
        setup(with: extent)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods

private extension BoundingBoxFace {
    func setup(with extent: SIMD3<Float>) {
        size = size(from: extent)
        geometry = makeGeometry()
        geometry?.firstMaterial?.diffuse.contents = UIColor.red.withAlphaComponent(0.9)
        translateAndRotate(face: face, extent: extent)
    }

    /// Creates a custom geometry using a polygon primitive type.
    ///
    /// The resulting polygon will have the same size as the size property.
    /// NOTE: We can change the implementation and use triangles instead of polygons and everything would be the same.
    func makeGeometry() -> SCNGeometry {
        let halfWidth = size.width / 2
        let halfHeight = size.height / 2
        let indices: [UInt32] = [4, 0, 1, 2, 3]
        let data = Data(bytes: indices, count: indices.count * MemoryLayout<UInt32>.size)

        let vertices = SCNGeometrySource(vertices: [
            SCNVector3(-halfWidth, halfHeight, 0),
            SCNVector3(-halfWidth, -halfHeight, 0),
            SCNVector3(halfWidth, -halfHeight, 0),
            SCNVector3(halfWidth, halfHeight, 0)
        ])

        let polygonElement = SCNGeometryElement(
            data: data,
            primitiveType: .polygon,
            primitiveCount: 1,
            bytesPerIndex: MemoryLayout<UInt32>.size
        )

        return SCNGeometry(
            sources: [vertices],
            elements: [polygonElement]
        )
    }

    /// Returns the size for the specified extent along two axis based on the face.
    func size(from extent: SIMD3<Float>) -> CGSize {
        switch face {
        case .front, .back:
            return CGSize(width: CGFloat(extent.x), height: CGFloat(extent.y))
        case .left, .right:
            return CGSize(width: CGFloat(extent.z), height: CGFloat(extent.y))
        case .bottom, .top:
            return CGSize(width: CGFloat(extent.x), height: CGFloat(extent.z))
        }
    }

    /// Translates and rotates the node so that it correctly matches the faces it represents.
    ///
    /// By default the node's geometry will be parallel and facing the camera.
    func translateAndRotate(face: Face, extent: SIMD3<Float>) {
        let angle: Float = .pi
        switch face {
        case .front:
            simdLocalTranslate(by: SIMD3<Float>(0, 0, extent.z / 2))
        case .back:
            simdLocalTranslate(by: SIMD3<Float>(0, 0, -extent.z / 2))
            simdLocalRotate(by: simd_quatf(angle: angle, axis: .y))
        case .left:
            simdLocalTranslate(by: SIMD3<Float>(-extent.x / 2, 0, 0))
            simdLocalRotate(by: simd_quatf(angle: -angle / 2, axis: .y))
        case .right:
            simdLocalTranslate(by: SIMD3<Float>(extent.x / 2, 0, 0))
            simdLocalRotate(by: simd_quatf(angle: angle / 2, axis: .y))
        case .bottom:
            simdLocalTranslate(by: SIMD3<Float>(0, -extent.y / 2, 0))
            simdLocalRotate(by: simd_quatf(angle: angle / 2, axis: .x))
        case .top:
            simdLocalTranslate(by: SIMD3<Float>(0, extent.y / 2, 0))
            simdLocalRotate(by: simd_quatf(angle: -angle / 2, axis: .x))
        }
    }
}
