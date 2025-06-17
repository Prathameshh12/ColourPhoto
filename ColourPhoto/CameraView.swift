import SwiftUI

struct CameraView: View {
    let targetColor: Color
    var namespace: Namespace.ID

    @State private var image: UIImage?
    @State private var isPickerPresented = false
    @State private var isMatch: Bool?
    @Environment(\.dismiss) var dismiss

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                LinearGradient(colors: [.blue.opacity(0.2), .purple.opacity(0.1)],
                               startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                BlobBackground()
                    .blur(radius: 70)
                    .opacity(0.12)
                    .offset(x: -80, y: -80)
                    .scaleEffect(0.6)

                VStack(spacing: 20) {
                    Spacer(minLength: 50)

                    // Title
                    Text("Match Today's Colour")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(
                            LinearGradient(colors: [.blue, .purple],
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing)
                        )
                        .padding(.horizontal, 30)

                    // Target Color Circle
                    ModernColorCircle(color: targetColor, namespace: namespace)


                    // Image & Result
                    Group {
                        if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: geometry.size.height * 0.25)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 6)
                                .padding(.horizontal, 24)
                                .transition(.opacity)
                                .animation(.easeInOut(duration: 0.3), value: image)

                            if let isMatch = isMatch {
                                Label {
                                    Text(isMatch ? "Great Match!" : "Try Again")
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                } icon: {
                                    Image(systemName: isMatch ? "checkmark.seal.fill" : "xmark.seal.fill")
                                        .font(.title3)
                                }
                                .foregroundColor(isMatch ? .green : .red)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                                .transition(.opacity)
                                .animation(.easeInOut(duration: 0.3), value: isMatch)
                            }
                        } else {
                            Text("Take a photo that matches the colour above. (Even a shade of it counts!)")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)
                                .transition(.opacity)
                        }
                    }

                    Spacer()

                    // Buttons
                    if image == nil {
                        takePhotoButton
                    } else {
                        HStack(spacing: 20) {
                            retakeButton
                        }
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.3), value: image)
                        .padding(.horizontal, 40)
                    }

                    Spacer(minLength: 30)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .animation(.easeInOut(duration: 0.3), value: image)
            }
        }
        .sheet(isPresented: $isPickerPresented) {
            ImagePicker(image: $image) { uiImage in
                DispatchQueue.global(qos: .userInitiated).async {
                    let match = ColorDetector.doesImage(uiImage, contain: UIColor(targetColor))

                    DispatchQueue.main.async {
                        withAnimation {
                            self.image = uiImage
                            self.isMatch = match
                        }
                    }
                }
            }
        }
    }

    private var takePhotoButton: some View {
        Button {
            isPickerPresented = true
        } label: {
            Text("Take a Photo")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing)
                )
                .foregroundColor(.white)
                .cornerRadius(20)
                .shadow(color: .purple.opacity(0.4), radius: 8, x: 0, y: 4)
                .padding(.horizontal, 40)
        }
    }

    private var retakeButton: some View {
        Button {
            withAnimation {
                image = nil
                isMatch = nil
            }
        } label: {
            Text("Retake Photo")
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .strokeBorder(Color.purple.opacity(0.4), lineWidth: 1.5)
                        .background(.ultraThinMaterial)
                )
                .foregroundColor(.primary)
        }
    }
}
struct ModernColorCircle: View {
    let color: Color
    var namespace: Namespace.ID

    @State private var isTapped = false
    @State private var pulse = false
    let feedback = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        ZStack {
            // Glowing outer ring
            Circle()
                .stroke(
                    LinearGradient(colors: [color.opacity(0.5), color.opacity(0.15)],
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing),
                    lineWidth: 8
                )
                .frame(width: 130, height: 130)
                .blur(radius: 2)
                .opacity(pulse ? 0.6 : 0.3)
                .scaleEffect(pulse ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulse)

            // Filled circle
            Circle()
                .fill(color)
                .frame(width: 120, height: 120)
                .matchedGeometryEffect(id: "color", in: namespace)
                .scaleEffect(isTapped ? 0.94 : 1.0)
                .shadow(color: color.opacity(0.3), radius: 16, x: 0, y: 8)
                .animation(.spring(response: 0.4, dampingFraction: 0.5), value: isTapped)
        }
        .onTapGesture {
            isTapped = true
            feedback.impactOccurred()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isTapped = false
            }
        }
        .onAppear {
            pulse = true
        }
    }
}
