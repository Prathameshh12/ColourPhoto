import SwiftUI
import UIKit

// MARK: - BlobView (animated blobs background)
struct BlobView: View {
    var color: Color
    var delay: Double = 0
    var blur: CGFloat = 30
    var size: CGFloat = 240

    @State private var offset = CGSize.zero
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 0.8

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .blur(radius: blur)
            .opacity(opacity)
            .scaleEffect(scale)
            .offset(offset)
            .onAppear {
                withAnimation(.easeInOut(duration: 6).delay(delay).repeatForever(autoreverses: true)) {
                    offset = CGSize(width: .random(in: -80...80), height: .random(in: -100...100))
                    scale = .random(in: 0.9...1.3)
                    opacity = .random(in: 0.4...0.9)
                }
            }
    }
}
