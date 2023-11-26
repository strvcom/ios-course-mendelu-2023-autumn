//
//  CVPixelBuffer+Extensions.swift
//  SampleARApp
//
//  Created by Tony Ngo on 11.10.2022.
//

import Vision

extension CVPixelBuffer {
    var width: Int {
        CVPixelBufferGetWidth(self)
    }

    var height: Int {
        CVPixelBufferGetHeight(self)
    }
}
