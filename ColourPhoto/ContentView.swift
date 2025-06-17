import SwiftUI

struct ContentView: View {
    @State private var navigateToCamera = false
    @Namespace var animation
    @StateObject private var colorManager = ColorManager()

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.blue.opacity(0.2), .purple.opacity(0.1)],
                               startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(spacing: 40) {
                    Spacer(minLength: 80)

                    Text("Welcome to Colour Capture")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(
                            LinearGradient(colors: [.blue, .purple],
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing)
                        )
                        .padding(.horizontal, 30)

                    Text("Find today's colour, capture a photo matching it, and take a moment to refresh yourself.")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 40)

                    Spacer()

                    NavigationLink(destination:
                        CameraView(targetColor: colorManager.todayColor, namespace: animation)
                            .environmentObject(colorManager)
                    , isActive: $navigateToCamera) {
                        EmptyView()
                    }

                    Button {
                        navigateToCamera = true
                    } label: {
                        Text("Let's Go")
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

                    Spacer(minLength: 40)
                }
                .padding(.vertical)
            }
            .onAppear {
                colorManager.loadTodayColor()
            }
        }
    }
}
