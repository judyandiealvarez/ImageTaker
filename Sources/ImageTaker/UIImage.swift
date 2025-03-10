//
//  UIImage.swift
//  ImageTaker
//
//  Created by Judy Alvarez on 10/03/25.
//


import SwiftUI
import Foundation
import UIKit

extension UIImage {
    public func cropToSquare() -> UIImage {
        let side = min(self.size.width, self.size.height)
        let xxx = (self.size.width - side) / 2.0
        let yyy = (self.size.height - side) / 2.0

        let cropRect = CGRect(x: xxx, y: yyy, width: side, height: side)
        if let croppedCGImage = self.cgImage?.cropping(to: cropRect) {
            return UIImage(cgImage: croppedCGImage, scale: self.scale, orientation: self.imageOrientation)
        }
        return self
    }

    public func rotateClockwise(degrees: CGFloat) -> UIImage {
        let radians = degrees * .pi / 180.0

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()!

        context.translateBy(x: size.width / 2, y: size.height / 2)
        context.rotate(by: radians)

        let origin = CGPoint(x: -size.width / 2, y: -size.height / 2)
        draw(at: origin)

        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return rotatedImage ?? self
    }

    public func resize(width: Double, height: Double = 0) -> UIImage {
        let size = CGSize(width: width, height: height == 0 ? width : height)
        let renderer = UIGraphicsImageRenderer(size: size)

        let resizedImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }

        return resizedImage
    }

    public func fixImageOrientation() -> UIImage? {
        guard imageOrientation != .up else { return self }

        var transform: CGAffineTransform = .identity
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform
                .translatedBy(x: size.width, y: size.height).rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform
                .translatedBy(x: size.width, y: 0).rotated(by: .pi)
        case .right, .rightMirrored:
            transform = transform
                .translatedBy(x: 0, y: size.height).rotated(by: -.pi/2)
        case .upMirrored:
            transform = transform
                .translatedBy(x: size.width, y: 0).scaledBy(x: -1, y: 1)
        default:
            break
        }

        guard
            let cgImage = cgImage,
            let colorSpace = cgImage.colorSpace,
            let context = CGContext(
                data: nil, width: Int(size.width), height: Int(size.height),
                bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0,
                space: colorSpace, bitmapInfo: cgImage.bitmapInfo.rawValue
            )
        else { return self }
        context.concatenate(transform)

        var rect: CGRect
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            rect = CGRect(x: 0, y: 0, width: size.height, height: size.width)
        default:
            rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        }

        context.draw(cgImage, in: rect)
        return context.makeImage().map { UIImage(cgImage: $0) } ?? self
    }

}
