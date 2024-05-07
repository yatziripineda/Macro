//
//  CameraView.swift
//  Macro
//
//  Created by Jose Miguel Torres Chavez Nava on 06/05/24.
//

import SwiftUI
import AVFoundation

/// Vista que maneja la cámara.
struct CameraView: UIViewControllerRepresentable {
    // Binding para una imagen que permitirá actualizar la imagen en la vista que muestra esta cámara.
    @Binding var image: UIImage?
    // Binding para controlar la visibilidad de esta vista de cámara desde otra vista.
    @Binding var isShown: Bool

    /// Configuramos un UIImagePickerController (un ViewController) para obtener una imagen desde la cámara.
    func makeUIViewController(context: Context) -> UIImagePickerController {
        // Creamos un controlador de selección de imagen.
        let picker = UIImagePickerController()
        // Establecemos el delegado del picker al coordinador que gestionará los eventos del UIImagePickerController.
        picker.delegate = context.coordinator
        // Especificamos que la fuente de imágenes debe ser la cámara del dispositivo.
        picker.sourceType = .camera
        // Regresamos la imagen obtenida en un picker.
        return picker
    }

    /// Actualizamos el UIViewController con nueva información. En este caso, no necesitamos hacer nada aquí.
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    /// Creamos un coordinador que ayudará a manejar la comunicación entre este representable de UIKit y SwiftUI.
    func makeCoordinator() -> Coordinator {
        // Instanciamos un nuevo Coordinador, pasando una referencia a esta instancia de CameraView.
        Coordinator(self)
    }

    /// Definimos una clase interna Coordinator que hereda de NSObject y cumple con los protocolos necesarios para actuar como delegado de UINavigationController y UIImagePickerController.
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        // Mantenemos una referencia a la vista de cámara para poder actualizarla.
        var parent: CameraView

        /* Inicializamos el coordinador con la vista de cámara. */
        init(_ parent: CameraView) {
            self.parent = parent
        }

        /// Maneja el evento de finalización de selección de imagen.
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // Extraemos la imagen original seleccionada.
            if let image = info[.originalImage] as? UIImage {
                // Asignamos la imagen al binding de la vista de cámara para que se pueda usar en otras vistas.
                parent.image = image
            }
            // Cerramos la vista de la cámara estableciendo isShown en falso.
            parent.isShown = false
        }
    }
}
