//
//  SCNGeometrySource+Extension.swift
//  SampleARApp
//
//  Created by Tony Ngo on 18.10.2022.
//

import SceneKit

extension SCNGeometrySource {
    /// Initializes a `SCNGeometrySource` with a list of colors as `SCNVector3`s`.
    convenience init(colors: [SCNVector3]) {
        let colorData = Data(bytes: colors, count: MemoryLayout<SCNVector3>.size * colors.count)

        self.init(
            data: colorData,
            semantic: .color,
            vectorCount: colors.count,
            usesFloatComponents: true,
            componentsPerVector: 3,
            bytesPerComponent: MemoryLayout<Float>.size,
            dataOffset: 0,
            dataStride: MemoryLayout<SCNVector3>.size
        )
    }
}
