//
//  TakePhotoView.swift
//  Macro
//
//  Created by Jose Miguel Torres Chavez Nava on 06/05/24.
//

import SwiftUI

/// UI with a button to capture an image with the camera.
struct TakePhotoView: View {

    // Controls the visibility of the camera interface.
    @State private var showCamera = false
    // Stores the image captured by the camera.
    @State private var image: UIImage?
    // Receives information about the text recognized in the image.
    @State private var recognizedData: [(String, CGRect)] = []
    
    var body: some View {
        VStack {
            Button("Open Camera") {
                self.showCamera = true
            }
            /* If recognizedData contains data, we display it. */
            if !recognizedData.isEmpty {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(recognizedData.indices, id: \.self) { index in
                            let data = recognizedData[index]
                            Text("Text: \(data.0)")
                            Text("Position: \(data.1.debugDescription)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                }
            }
        }
        // Modal view that appears when showCamera is true.
        .sheet(isPresented: $showCamera) {
            CameraView(image: $image, isShown: $showCamera)
        }
        // Activates as soon as the user taps "use photo"
        .onChange(of: image) { oldValue, newValue in
            // If there is a new value for the image, we define it as "validImage"
            if let validImage = newValue {
                // We call a function to process the image
                processImage(validImage) { recognizedData in
                    // Here we could use Async/Await to ensure linear programming.
                    DispatchQueue.main.async {
                        if let data = recognizedData {
                            /* We update the State variable to get the recognition data */
                            self.recognizedData = data
                        } else {
                            print("No text was recognized.")
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    TakePhotoView()
}
