//
//  simd_float3+Extensions.swift
//  DimensionsAR
//
//  Created by Tony Ngo on 05.10.2022.
//

import SceneKit

extension simd_float3 {
    /// Creates a new vector from the simd_float4 — omitting the fourth element of the vector.
    ///
    /// The fourth element of the vector are usually the values of the last row in a tranformation matrix,
    /// which are used for projection purposes.
    init(_ simd: simd_float4) {
        self.init(simd.x, simd.y, simd.z)
    }
}
