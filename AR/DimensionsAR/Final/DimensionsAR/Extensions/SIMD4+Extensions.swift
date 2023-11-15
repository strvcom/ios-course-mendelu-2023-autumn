//
//  SIMD4+Extensions.swift
//  DimensionsAR
//
//  Created by Tony Ngo on 05.10.2022.
//

import SceneKit

extension SIMD4 {
    var xyz: SIMD3<Scalar> {
        SIMD3<Scalar>(x, y, z)
    }
}
