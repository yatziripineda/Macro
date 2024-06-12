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
    // Variable para cerrar la vista en una jerarquía de navegación
    @Environment(\.dismiss) var dismiss
    @Binding var recognizedData: [(String, CGRect)]
    
    /// We configure a UIImagePickerController (a ViewController) to obtain an image from the camera or gallery. This is necessary for the CameraView structure to adopt the UIViewControllerRepresentable protocol.
    func makeUIViewController(context: Context) -> UIViewController {
        // Create a container view controller to hold the camera and button.
        let containerViewController = UIViewController()
        
        // We create an image picker controller.
        let picker = UIImagePickerController()
        // We assign the delegate of the picker as the coordinator who will manage the events of the UIImagePickerController.
        picker.delegate = context.coordinator
        // We specify that the image source should be the camera of the device.
        picker.sourceType = .camera
        
        // Add the picker to the container.
        containerViewController.addChild(picker)
        containerViewController.view.addSubview(picker.view)
        picker.view.frame = containerViewController.view.frame
        picker.didMove(toParent: containerViewController)
        
        // Create a button to open the gallery.
        let button = UIButton(type: .system)
        button.setTitle("Choose from Gallery", for: .normal)
        button.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.7)
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(context.coordinator, action: #selector(context.coordinator.openGallery), for: .touchUpInside)
        
        // Add the button to the container view.
        containerViewController.view.addSubview(button)
        
        // Position the button.
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: containerViewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            button.centerXAnchor.constraint(equalTo: containerViewController.view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        return containerViewController
    }

    /// Here we can update the UIViewController with new information. This function is required to adopt the UIViewControllerRepresentable protocol but in this case, we do not need to do anything here.
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

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
                processImage(image) { recognizedData in
                    // Here we could use Async/Await to ensure linear programming.
                    DispatchQueue.main.async {
                        if let data = recognizedData {
                            /* We update the State variable to get the recognition data */
                            self.parent.recognizedData = data
                        } else {
                            print("No text was recognized.")
                        }
                    }
                }
            }
            // We close the camera view.
            parent.isShown = false
        }
        
        /// Opens the gallery for the user to select an image.
        @objc func openGallery() {
            parent.isShown = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .photoLibrary
                UIApplication.shared.windows.first?.rootViewController?.present(picker, animated: true, completion: nil)
            }
        }
    }
}
