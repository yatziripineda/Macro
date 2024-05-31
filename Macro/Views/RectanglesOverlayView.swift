//
//  RectanglesOverlay.swift
//  Macro
//
//  Created by Jose Miguel Torres Chavez Nava on 08/05/24.
//

import SwiftUI

struct RectanglesOverlay: View {
    
    var labels: [DiagramLabel]
    @Binding var currentIndex: Int
    @Binding var isQuiz: Bool
    
    var body: some View {
        // Usamos un canvas para dibujar gráficos 2D dentro de una vista SwiftUI.
        Canvas { context, size in
            for (index, label) in labels.enumerated() {
                let rect = label.toCGRect()
                if isQuiz {
                    if index == currentIndex {
                        context.fill(Path(rect), with: .color(.red)) // We change the color of the current rectangle
                    } else {
                        context.fill(Path(rect), with: .color(.black.opacity(1.0)))
                    }
                } else {
                    context.fill(Path(rect), with: .color(.black.opacity(1.0)))
                }
            }
        }
    }
}

