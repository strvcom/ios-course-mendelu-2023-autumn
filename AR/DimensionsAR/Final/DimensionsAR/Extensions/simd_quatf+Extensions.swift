//
//  simd_quatf+Extensions.swift
//  DimensionsAR
//
//  Created by Tony Ngo on 05.10.2022.
//

import SceneKit

extension simd_quatf {
    /// A quaternion whose action is a rotation by angle radians about axis.
    init(angle: Float, axis: Axis) {
        self.init(angle: angle, axis: axis.normal)
    }
}
