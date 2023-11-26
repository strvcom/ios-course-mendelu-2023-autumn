//
//  simd_float4x4+Extension.swift
//  SampleARApp
//
//  Created by Tony Ngo on 18.10.2022.
//

import SceneKit

extension simd_float4x4  {
    /// Returns a 3x1 translation vector from the matrix.
    var translation: simd_float3 {
        simd_make_float3(columns.3)
    }
}
