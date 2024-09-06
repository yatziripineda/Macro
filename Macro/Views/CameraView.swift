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
    @Binding var recognizedData:[(String,CGRect)]
    
    /// We configure a UIImagePickerController (a ViewController) to obtain an image from the camera. This is necessary for the CameraView structure to adopt the UIViewControllerRepresentable protocol.
    func makeUIViewController(context: Context) -> UIViewController {
        checkCameraAuthorizationStatus(context: context)
    }
    
    /// Here we can update the UIViewController with new information. This function is required to adopt the UIViewControllerRepresentable protocol but in this case, we do not need to do anything here.
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    /// We create a coordinator that will help manage communication between this UIKit representable and SwiftUI.
    func makeCoordinator() -> Coordinator {
        // We instantiate a new Coordinator, passing a reference to this instance of CameraView.
        Coordinator(self)
    }
    
    /// This function checks the camera authorization status and handles the logic accordingly.
    private func checkCameraAuthorizationStatus(context: Context) -> UIViewController {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // Camera access is authorized, proceed with presenting the UIImagePickerController.
            return setupCameraPicker(context: context)
        case .notDetermined:
            // Camera access has not been requested yet, so we request access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        // If granted, proceed with presenting the UIImagePickerController.
                        context.coordinator.parent.isShown = true
                    } else {
                        // If denied, present an alert.
                        context.coordinator.presentCameraAccessDeniedAlert()
                    }
                }
            }
            return UIViewController() // Return an empty view controller to fulfill the method signature.
        case .denied, .restricted:
            // Camera access has been denied or restricted, present an alert.
            context.coordinator.presentCameraAccessDeniedAlert()
            return UIViewController() // Return an empty view controller to fulfill the method signature.
        @unknown default:
            fatalError("Unknown camera authorization status.")
        }
    }
    
    /// This function sets up the UIImagePickerController if access is granted.
    private func setupCameraPicker(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    /// We define an inner class Coordinator that inherits from NSObject and meets the necessary protocols to act as delegate for UINavigationController and UIImagePickerController.
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        // We maintain a reference to the camera view so we can update it.
        var parent: CameraView
        
        /* We initialize objects of this class with the reference to the camera view. */
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        /// Presents an alert to the user when camera access is denied or restricted.
        func presentCameraAccessDeniedAlert() {
            let alert = UIAlertController(
                title: "Camera Access Required",
                message: "Camera access is required to take photos. Please enable camera access in the settings.",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                self.parent.isShown = false
            }))
            
            alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings)
                }
            }))
            
            if let topController = UIApplication.shared.windows.first?.rootViewController {
                topController.present(alert, animated: true, completion: nil)
            }
        }
        
        /// Handles the event of image selection completion.
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // We extract the selected original image.
            if let image = info[.originalImage] as? UIImage {
                // We assign the image to the camera view's binding so it can be used in other views.
                processImage(image) { [weak self] recognizedData in
                    // Here we could use Async/Await to ensure linear programming.
                    DispatchQueue.main.async {
                        if let data = recognizedData {
                            /* We update the State variable to get the recognition data */
                            self?.parent.recognizedData = data
                            self?.parent.image = image
                            self?.parent.isShown = false
                        } else {
                            print("No text was recognized.")
                            
                            // Optionally, show an alert to the user indicating that no text was recognized and they should try again.
                            let alert = UIAlertController(title: "No Text Detected on picture", message: "Please retake the photo.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                                // Dismiss the alert and reset the picker.
                                picker.dismiss(animated: true, completion: {
                                    // Dismiss the whole view
                                    self?.parent.dismiss()
                                })
                            }))
                            
                            picker.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
}
