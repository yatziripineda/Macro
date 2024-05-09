//
//  CameraView.swift
//  Macro
//
//  Created by Jose Miguel Torres Chavez Nava on 06/05/24.
//

import SwiftUI
import AVFoundation

/// View that handles the camera.
struct CameraView: UIViewControllerRepresentable {
    // Will allow updating the image in the view displaying this camera.
    @Binding var image: UIImage?
    // Controls the visibility of this camera view from another view.
    @Binding var isShown: Bool

    /// We configure a UIImagePickerController (a ViewController) to obtain an image from the camera. This is necessary for the CameraView structure to adopt the UIViewControllerRepresentable protocol.
    func makeUIViewController(context: Context) -> UIImagePickerController {
        // We create an image picker controller.
        let picker = UIImagePickerController()
        // We assign the delegate of the picker as the coordinator who will manage the events of the UIImagePickerController.
        picker.delegate = context.coordinator
        // We specify that the image source should be the camera of the device.
        picker.sourceType = .camera
        // We return the image picker controller.
        return picker
    }

    /// Here we can update the UIViewController with new information. This function is required to adopt the UIViewControllerRepresentable protocol but in this case, we do not need to do anything here.
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    /// We create a coordinator that will help manage communication between this UIKit representable and SwiftUI.
    func makeCoordinator() -> Coordinator {
        // We instantiate a new Coordinator, passing a reference to this instance of CameraView.
        Coordinator(self)
    }

    /// We define an inner class Coordinator that inherits from NSObject and meets the necessary protocols to act as delegate for UINavigationController and UIImagePickerController.
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        // We maintain a reference to the camera view so we can update it.
        var parent: CameraView
        /* We initialize objects of this class with the reference to the camera view. */
        init(_ parent: CameraView) {
            self.parent = parent
        }
        /// Handles the event of image selection completion.
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // We extract the selected original image.
            if let image = info[.originalImage] as? UIImage {
                // We assign the image to the camera view's binding so it can be used in other views.
                parent.image = image
            }
            // We close the camera view.
            parent.isShown = false
        }
    }
    
}
