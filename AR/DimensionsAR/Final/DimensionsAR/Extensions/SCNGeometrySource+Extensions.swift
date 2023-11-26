//
//  SCNGeometrySource+Extensions.swift
//  DimensionsAR
//
//  Created by Tony Ngo on 10.10.2022.
//

import ARKit

extension SCNGeometrySource {
    /// Creates a geometry source from the specified mesh data.
    ///
    /// In other words, converts `ARGeometrySource` type to `SCNGeometrySource` type.
    /// - parameter source: The mesh data.
    /// - parameter semantic: The semantic of the specified mesh data.
    static func source(
        from source: ARGeometrySource,
        semantic: SCNGeometrySource.Semantic
    ) -> SCNGeometrySource {
        SCNGeometrySource(
            buffer: source.buffer,
            vertexFormat: source.format,
            semantic: semantic,
            vertexCount: source.count,
            dataOffset: source.offset,
            dataStride: source.stride
        )
    }
}
