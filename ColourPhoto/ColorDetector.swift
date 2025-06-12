//
//  ColorDetector.swift
//  ColourPhoto
//
//  Created by Prathamesh Ahire on 12/6/2025.
//


//
//  ColorDetector.swift
//  colourLook
//
//  Created by Prathamesh Ahire on 29/5/2025.
//


import UIKit

struct ColorDetector {
    static func doesImage(_ image: UIImage, contain targetColor: UIColor, threshold: CGFloat = 0.3) -> Bool {
        guard let cgImage = image.cgImage else { return false }

        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        let rawData = calloc(height * width * bytesPerPixel, MemoryLayout<UInt8>.size)
        defer { free(rawData) }

        let context = CGContext(data: rawData,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: bytesPerPixel * width,
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)

        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        let pixelBuffer = rawData?.assumingMemoryBound(to: UInt8.self)
        let target = targetColor.rgbComponents

        var matchCount = 0
        let totalPixels = width * height

        for i in 0..<totalPixels {
            let offset = i * bytesPerPixel
            let r = CGFloat(pixelBuffer![offset]) / 255.0
            let g = CGFloat(pixelBuffer![offset + 1]) / 255.0
            let b = CGFloat(pixelBuffer![offset + 2]) / 255.0

            let diff = abs(r - target.r) + abs(g - target.g) + abs(b - target.b)
            if diff < threshold {
                matchCount += 1
            }
        }

        let matchRatio = CGFloat(matchCount) / CGFloat(totalPixels)
        return matchRatio > 0.01
    }
}

extension UIColor {
    var rgbComponents: (r: CGFloat, g: CGFloat, b: CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: nil)
        return (r, g, b)
    }
}
