//
//  ContentView.swift
//  colourLook
//
//  Created by Prathamesh Ahire on 29/5/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var colorManager = ColorManager()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Today's Color")
                    .font(.largeTitle)
                    .bold()

                Circle()
                    .fill(colorManager.todayColor)
                    .frame(width: 150, height: 150)
                    .shadow(radius: 10)

                NavigationLink("Take a Photo", destination: CameraView(targetColor: colorManager.todayColor))

                Spacer()
            }
            .padding()
        }
        .environmentObject(colorManager)
    }
}

#Preview {
    ContentView()
}
