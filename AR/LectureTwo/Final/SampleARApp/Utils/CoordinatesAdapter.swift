//
//  CoordinatesAdapter.swift
//  SampleARApp
//
//  Created by Tony Ngo on 11.10.2022.
//

import UIKit

struct CoordinatesAdapter {
    var imageSize: CGSize = .zero
    let screenSize: CGSize
}

extension CoordinatesAdapter {
    /// Converts the specified point from the image provided by the camera to a point in the screen's coordinate system.
    /// - parameter normalizedImagePoint: A normalized coordinates of a point in the image.
    /// - returns: A point in the screen's coordinate system.
    func screenCoordinates(normalizedImagePoint: CGPoint) -> CGPoint {
        let normalizedScreenPoint = normalizeScreen(point: normalizedImagePoint)
        return CGPoint(
            x: screenSize.width * normalizedScreenPoint.x,
            y: screenSize.height * normalizedScreenPoint.y
        )
    }
}

private extension CoordinatesAdapter {
    /// A height scale factor between the color image and the screen.
    var multiplier: Double {
        imageSize.height / screenSize.height
    }

    /// A scaled screen size by `multiplier`.
    var multipliedScreenSize: CGSize {
        CGSize(
            width: screenSize.width * multiplier,
            height: screenSize.height * multiplier
        )
    }

    /// A normalized width value of non-visible area relative to the color image.
    var nonVisibleAreaWidth: Double {
        (imageSize.width - multipliedScreenSize.width) / 2 / imageSize.width
    }

    /// A normalized range representing a visible area relative to the color image.
    var visibleAreaRange: ClosedRange<Double> {
        nonVisibleAreaWidth...1 - nonVisibleAreaWidth
    }

    /// A normalized width value of visible area relative to the color image.
    var visibleAreaWidth: Double {
        visibleAreaRange.upperBound - visibleAreaRange.lowerBound
    }

    /// Returns a normalized `CGPoint` representing a point in the screen.
    func normalizeScreen(point: CGPoint) -> CGPoint {
        CGPoint(
            x: (point.x - visibleAreaRange.lowerBound) / visibleAreaWidth,
            y: point.y
        )
    }
}
