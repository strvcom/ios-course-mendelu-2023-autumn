//
//  Ray.swift
//  DimensionsAR
//
//  Created by Tony Ngo on 05.10.2022.
//

import SceneKit

struct Ray {
    /// A ray's origin as a point of intersection with a geometry in the world coordinates.
    let origin: SIMD3<Float>

    /// A ray's direction as a normalized vector in the world coordinates. This property is set as the face's normal vector.
    let direction: SIMD3<Float>

    init(origin: SIMD3<Float>, direction: SIMD3<Float>) {
        self.origin = origin
        self.direction = direction
    }
}
