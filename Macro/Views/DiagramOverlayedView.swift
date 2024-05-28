//
//  DiagramOverlayedView.swift
//  Macro
//
//  Created by Jose Miguel Torres Chavez Nava on 24/05/24.
//

import SwiftUI

struct DiagramOverlayedView: View {
    
    // Parámetro para la imagen recibida de la cámara
    var uiImage: UIImage
    /* Parámetros para los rectángulos */
    var labels: [DiagramLabel]
    @Binding var currentIndex: Int
    
    // Variable to control the overlay visibility
    @Binding var overlayVisibility: Bool
    
    var body: some View {
        GeometryReader { geometry in
            let imageSize = CGSize(width: uiImage.size.width, height: uiImage.size.height)
            let scale = calculateScale(geometrySize: geometry.size, imageSize: imageSize)
            let offset = calculateOffset(geometrySize: geometry.size, imageSize: imageSize, scale: scale)
            
            ZStack {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                if overlayVisibility {
                    RectanglesOverlay(labels: scaledLabels(labels: labels, scale: scale, offset: offset), currentIndex: $currentIndex)
                }
            }
        }
    }
    
    private func calculateScale(geometrySize: CGSize, imageSize: CGSize) -> CGFloat {
        let widthScale = geometrySize.width / imageSize.width
        let heightScale = geometrySize.height / imageSize.height
        return min(widthScale, heightScale)
    }
    
    private func calculateOffset(geometrySize: CGSize, imageSize: CGSize, scale: CGFloat) -> CGPoint {
        let scaledImageSize = CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
        let offsetX = (geometrySize.width - scaledImageSize.width) / 2
        let offsetY = (geometrySize.height - scaledImageSize.height) / 2
        return CGPoint(x: offsetX, y: offsetY)
    }
    
    private func scaledLabels(labels: [DiagramLabel], scale: CGFloat, offset: CGPoint) -> [DiagramLabel] {
        return labels.map { label in
            let scaledRect = CGRect(
                x: label.originX * scale + offset.x,
                y: label.originY * scale + offset.y,
                width: label.width * scale,
                height: label.height * scale
            )
            return DiagramLabel(text: label.text, rectangle: scaledRect)
        }
    }
    
}
