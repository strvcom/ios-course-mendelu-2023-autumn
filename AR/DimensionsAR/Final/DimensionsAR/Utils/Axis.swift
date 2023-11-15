//
//  Axis.swift
//  DimensionsAR
//
//  Created by Tony Ngo on 05.10.2022.
//

import Foundation

enum Axis {
    case x, y, z
}

extension Axis {
    /// The axis normal vector.
    var normal: SIMD3<Float> {
        switch self {
        case .x:
            return SIMD3(1, 0, 0)
        case .y:
            return SIMD3(0, 1, 0)
        case .z:
            return SIMD3(0, 0, 1)
        }
    }
}
