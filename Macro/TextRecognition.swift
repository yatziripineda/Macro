//
//  TextRecognition.swift
//  Macro
//
//  Created by Jose Miguel Torres Chavez Nava on 06/05/24.
//

import SwiftUI
import Vision

/// We perform text recognition in images by making an image analysis request to Vision, handle potential errors, and convert normalized rectangle coordinates to image coordinates and pass the results through a completion closure.
func processImage(_ image: UIImage, completion: @escaping ([(String, CGRect)]?) -> Void) {
    /* We ensure the image has a CGImage representation and if not, we exit the function. */
    guard let cgImage = image.cgImage else {
        completion(nil)
        return
    }

    /* We create a text recognition request using Vision. */
    let request = VNRecognizeTextRequest { request, error in
        /* We check that there are no errors and that the result can be interpreted as a collection of text observations. */
        guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
            // We print an error message if the request fails.
            print("Recognition failed: \(error?.localizedDescription ?? "Unknown error")")
            completion(nil)
            return
        }
        
        /* We map the observations to an array of tuples containing the recognized text and their bounding rectangles. */
        let recognizedStrings: [(String, CGRect)] = observations.compactMap { observation in
            /* We extract the most likely correct text and its bounding box. */
            guard let topCandidate = observation.topCandidates(1).first else { return nil }
            let boundingBox = observation.boundingBox
            // We convert the normalized coordinates of the bounding box to image coordinates.
            let imageRect = VNImageRectForNormalizedRect(boundingBox, Int(cgImage.width), Int(cgImage.height))
            // We return a tuple with the text and its box.
            return (topCandidate.string, imageRect)
        }
        // We send the obtained observations through the completion.
        completion(recognizedStrings)
    }
    
    // We configure and execute the text recognition request with Vision.
    let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    do {
        // We attempt to perform the request.
        try requestHandler.perform([request])
    } catch {
        // We print a message if the execution fails.
        print("Unable to perform the request: \(error)")
        completion(nil)
    }
}

/// Converts rectangles with normalized coordinates to image coordinates.
func VNImageRectForNormalizedRect(_ normalizedRect: CGRect, _ imageWidth: Int, _ imageHeight: Int) -> CGRect {
    /* We calculate the coordinates (x, y), as well as the width and height in real numbers */
    let x = normalizedRect.minX * CGFloat(imageWidth)
    let y = normalizedRect.minY * CGFloat(imageHeight)
    let width = normalizedRect.width * CGFloat(imageWidth)
    let height = normalizedRect.height * CGFloat(imageHeight)
    // We return the rectangle with real dimensions.
    return CGRect(x: x, y: y, width: width, height: height)
}
