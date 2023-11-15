//
//  BoundingBox.swift
//  DimensionsAR
//
//  Created by Tony Ngo on 06.10.2022.
//

import ARKit

final class BoundingBox: SCNNode {
    // MARK: - Public Properties

    var dimensions: Dimensions {
        return Dimensions(
            width: extent.x,
            height: extent.y,
            depth: extent.z
        )
    }

    /// The minimum size of the bounding box's extent.
    var minSize: Float = 0.1

    /// Represents the size of the box in all axis.
    ///
    /// Changing this property will re-render the box.
    var extent: SIMD3<Float> = .init(0.1, 0.1, 0.1) {
        didSet {
            extent = max(extent, minSize)
            render()
        }
    }

    // MARK: - Private Properties

    /// A parent node for all faces nodes of the box.
    private(set) var facesNode: SCNNode = .init()

    // MARK: - Initialization

    override init() {
        super.init()
        render()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension BoundingBox {
    func render() {
        removeFaces()
        renderFaces()
    }

    func removeFaces() {
        facesNode.childNodes.forEach { $0.removeFromParentNode() }
        facesNode.removeFromParentNode()
    }

    func renderFaces() {
        BoundingBoxFace.Face.allCases.forEach {
            let face = BoundingBoxFace($0, boundingBoxExtent: extent)
            facesNode.addChildNode(face)
        }
        addChildNode(facesNode)
    }
}

// MARK: - Dimensions

extension BoundingBox {
    struct Dimensions {
        let width: Float
        let height: Float
        let depth: Float
    }
}

extension BoundingBox.Dimensions {
    typealias FormattedDimensions = (width: String, height: String, depth: String)
    var formattedDimensions: FormattedDimensions {
        (width: string(from: width), height: string(from: height), depth: string(from: depth))
    }

    private static let formatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        formatter.locale = Locale(identifier: "cs_CZ")
        return formatter
    }()

    private func string(from value: Float) -> String {
        var measurement = Measurement(value: Double(value), unit: UnitLength.meters)
        if measurement.value < 1 {
            measurement.convert(to: .centimeters)
            Self.formatter.unitOptions = .providedUnit
        }
        Self.formatter.numberFormatter.maximumFractionDigits = 1
        return Self.formatter.string(from: measurement)
    }
}
