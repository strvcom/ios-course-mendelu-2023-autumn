//
//  ARMeshAnchor+Extensions.swift
//  DimensionsAR
//
//  Created by Tony Ngo on 10.10.2022.
//

import ARKit

extension ARMeshAnchor {
    func sceneGeometry() -> SCNGeometry? {
        let faces: ARGeometryElement = geometry.faces

        guard let primitiveType = SCNGeometryPrimitiveType(faces.primitiveType) else {
            return nil
        }

        let vertexSource: SCNGeometrySource = .source(from: geometry.vertices, semantic: .vertex)
        let normalsSource: SCNGeometrySource = .source(from: geometry.normals, semantic: .normal)
        let faceData = Data(bytes: faces.buffer.contents(), count: faces.buffer.length)
        let element = SCNGeometryElement(
            data: faceData,
            primitiveType: primitiveType,
            primitiveCount: faces.count,
            bytesPerIndex: faces.bytesPerIndex
        )

        let geometry = SCNGeometry(sources: [vertexSource, normalsSource], elements: [element])
        geometry.firstMaterial?.colorBufferWriteMask = []
        geometry.firstMaterial?.writesToDepthBuffer = true
        geometry.firstMaterial?.readsFromDepthBuffer = true
        return geometry
    }
}
