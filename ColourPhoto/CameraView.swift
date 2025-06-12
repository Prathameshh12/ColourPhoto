//
//  CameraView.swift
//  ColourPhoto
//
//  Created by Prathamesh Ahire on 12/6/2025.
//


//
//  CameraView.swift
//  colourLook
//
//  Created by Prathamesh Ahire on 29/5/2025.
//


import SwiftUI
import UIKit

struct CameraView: View {
    let targetColor: Color
    @State private var image: UIImage?
    @State private var isPickerPresented = false
    @State private var isMatch = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Find this color:")
                .font(.title2)
            Circle()
                .fill(targetColor)
                .frame(width: 100, height: 100)

            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .cornerRadius(12)
                    .shadow(radius: 8)

                Text(isMatch ? "✅ Match found!" : "❌ Try again")
                    .font(.headline)
                    .foregroundColor(isMatch ? .green : .red)
            }

            Button("Take Photo") {
                isPickerPresented = true
            }
            .padding()
            .buttonStyle(.borderedProminent)
        }
        .sheet(isPresented: $isPickerPresented) {
            ImagePicker(image: $image, onImagePicked: { uiImage in
                self.isMatch = ColorDetector.doesImage(uiImage, contain: UIColor(targetColor))
            })
        }
        .padding()
    }
}
