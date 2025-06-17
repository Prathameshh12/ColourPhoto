import UIKit

struct ColorDetector {
    static func doesImage(_ image: UIImage, contain color: UIColor, hueTolerance: CGFloat = 0.1) -> Bool {
        guard let cgImage = image.cgImage else { return false }

        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width

        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return false }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
        guard let pixelBuffer = context.data?.assumingMemoryBound(to: UInt8.self) else { return false }

        var matchCount = 0
        let pixelCount = width * height

        var targetHue: CGFloat = 0
        color.getHue(&targetHue, saturation: nil, brightness: nil, alpha: nil)

        for x in stride(from: 0, to: width, by: 4) {
            for y in stride(from: 0, to: height, by: 4) {
                let offset = (y * width + x) * 4
                let r = CGFloat(pixelBuffer[offset]) / 255.0
                let g = CGFloat(pixelBuffer[offset + 1]) / 255.0
                let b = CGFloat(pixelBuffer[offset + 2]) / 255.0

                var hue: CGFloat = 0
                UIColor(red: r, green: g, blue: b, alpha: 1).getHue(&hue, saturation: nil, brightness: nil, alpha: nil)

                let diff = abs(hue - targetHue)
                if diff < hueTolerance || abs(diff - 1.0) < hueTolerance {
                    matchCount += 1
                }
            }
        }

        let matchRatio = CGFloat(matchCount) / CGFloat(pixelCount)
        return matchRatio > 0.015
    }
}
