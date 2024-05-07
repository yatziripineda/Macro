//
//  TextRecognition.swift
//  Macro
//
//  Created by Jose Miguel Torres Chavez Nava on 06/05/24.
//

import SwiftUI
import AVFoundation
import Vision

/// Realizamos el reconocimiento de texto en imágenes usando el framework Vision de Apple, manejamos errores potenciales y convertimos coordenadas de rectángulos normalizados a coordenadas de imagen. Esta función es crucial para interpretar texto directamente desde imágenes capturadas o seleccionadas.
func processImage(_ image: UIImage) {
    /* Nos aseguramos de que la imagen tenga una representación CGImage y si no, salimos de la función. */
    guard let cgImage = image.cgImage else { return }

    /* Creamos una solicitud de reconocimiento de texto utilizando Vision. */
    let request = VNRecognizeTextRequest { request, error in
        /* Verificamos que no haya errores y que el resultado pueda ser interpretado como una colección de observaciones de texto. */
        guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
            // Imprimimos un mensaje de error si la petición falla.
            print("Recognition failed: \(error?.localizedDescription ?? "Unknown error")")
            return
        }

        /* Mapeamos las observaciones a un arreglo de tuplas que contienen el texto reconocido y sus rectángulos delimitadores. */
        let recognizedStrings: [(String, CGRect)] = observations.compactMap { observation in
            /* Extraemos el texto más probable de ser correcto y su caja delimitadora. */
            guard let topCandidate = observation.topCandidates(1).first else { return nil }
            let boundingBox = observation.boundingBox
            // Convertimos las coordenadas normalizadas de la caja delimitadora a coordenadas de la imagen.
            let imageRect = VNImageRectForNormalizedRect(boundingBox, Int(cgImage.width), Int(cgImage.height))
            // Retornamos una tupla con el texto y su caja.
            return (topCandidate.string, imageRect)
        }

        /* Iteramos sobre los textos reconocidos y sus cajas para imprimirlos. */
        for (text, rect) in recognizedStrings {
            print("Recognized text: \(text) in box: \(rect)")
        }
    }
    
    // Configuramos y ejecutamos la petición de reconocimiento de texto con Vision.
    let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    
    do {
        // Intentamos realizar la petición.
        try requestHandler.perform([request])
    } catch {
        // Imprimimos un mensaje si la ejecución falla.
        print("Unable to perform the request: \(error)")
    }
}

/// Convierte rectángulos con coordenadas normalizadas a coordenadas de imagen reales.
func VNImageRectForNormalizedRect(_ normalizedRect: CGRect, _ imageWidth: Int, _ imageHeight: Int) -> CGRect {
    /* Calculamos las coordenadas (x, y), así como el ancho y el alto en números reales */
    let x = normalizedRect.minX * CGFloat(imageWidth)
    let y = normalizedRect.minY * CGFloat(imageHeight)
    let width = normalizedRect.width * CGFloat(imageWidth)
    let height = normalizedRect.height * CGFloat(imageHeight)
    // Regresamos el rectángulo con dimensiones reales.
    return CGRect(x: x, y: y, width: width, height: height)
}
