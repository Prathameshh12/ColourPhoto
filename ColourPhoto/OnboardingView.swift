import SwiftUI

struct OnboardingView: View {
    @State private var animateText = false
    @State private var navigateToContent = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [.white, .blue.opacity(0.03)],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            BlobBackground()
                .blur(radius: 80)
                .opacity(0.4)
                .offset(x: -40, y: -60)
                .scaleEffect(animateText ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: animateText)

            VStack(spacing: 20) {
                Spacer()

                Text("Colour Capture")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .scaleEffect(animateText ? 1 : 0.9)
                    .opacity(animateText ? 1 : 0.5)
                    .animation(.spring(response: 1, dampingFraction: 0.6), value: animateText)

                Text("Capture. Embrace. Refresh.")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
                    .opacity(animateText ? 1 : 0)
                    .animation(.easeInOut(duration: 2).delay(0.5), value: animateText)

                Spacer()
            }
            .padding()
        }
        .onAppear {
            animateText = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    navigateToContent = true
                }
            }
        }
        .fullScreenCover(isPresented: $navigateToContent) {
            ContentView()
        }
    }
}
struct BlobBackground: View {
    @State private var rotate = false

    var body: some View {
        ZStack {
            BlobView(color: .blue.opacity(0.7), delay: 0, blur: 60, size: 320)
                .rotationEffect(.degrees(rotate ? 360 : 0))
                .offset(x: -50, y: -80)

            BlobView(color: .purple.opacity(0.8), delay: 2, blur: 40, size: 250)
                .offset(x: 60, y: 40)
        }
        .onAppear {
            withAnimation(.linear(duration: 30).repeatForever(autoreverses: false)) {
                rotate = true
            }
        }
    }
}
