//
//  TakePhotoView.swift
//  Macro
//
//  Created by Jose Miguel Torres Chavez Nava on 06/05/24.
//

import SwiftUI

/// Vista sencilla para capturar una fotografía desde el dispositivo físico.
struct TakePhotoView: View {

    // Controla la visibilidad de la interfaz de la cámara.
    @State private var showCamera = false
    // Almacena la imagen capturada por la cámara.
    @State private var image: UIImage?
    
    var body: some View {
        VStack {
            Button("Open Camera") {
                // Al pulsar el botón, se activa la cámara
                self.showCamera = true
            }
        }
        // Vista modal que se muestra cuando showCamera es true.
        .sheet(isPresented: $showCamera) {
            // Mostramos la vista de la cámara.
            CameraView(image: $image, isShown: $showCamera)
        }
        // Si se realizan cambios en la variable de la imagen...
        .onChange(of: image) { oldValue, newValue in
            // Verificamos si hay una nueva imagen válida.
            if let validImage = newValue {
                // Llamamos a una función para procesar la imagen si es válida.
                processImage(validImage)
            }
        }
    }
}


#Preview {
    TakePhotoView()
}
