//
//  SCNGeometryPrimitiveType+Extensions.swift
//  DimensionsAR
//
//  Created by Tony Ngo on 10.10.2022.
//

import ARKit

extension SCNGeometryPrimitiveType {
    init?(_ type: ARGeometryPrimitiveType) {
        switch type {
        case .triangle:
            self = .triangles
        case .line:
            self = .line
        default:
            return nil
        }
    }
}
