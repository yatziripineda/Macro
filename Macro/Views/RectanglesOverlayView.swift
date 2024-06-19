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
    @Binding var overlayVisibility: Bool
    @Binding var isCorrect: Bool?
    
    var body: some View {
        // Usamos un canvas para dibujar gráficos 2D dentro de una vista SwiftUI.
        Canvas { context, size in
            for (index, label) in labels.enumerated() {
                let rect = label.toCGRect()
                if isQuiz {
                    if index == currentIndex {
                        // Agregamos esta condición para mostrar el valor de la etiqueta en caso de que el usuario se equivoque.
                        if isCorrect ?? true {
                            context.fill(Path(rect), with: .color(.purple)) // We change the color of the current rectangle
                        } else {
                            context.fill(Path(rect), with: .color(.red.opacity(0.1))) // We change the color of the current rectangle
                        }
                    } else {
                        context.fill(Path(rect), with: .color(.black.opacity(overlayVisibility ? 1.0 : 0.1)))
                    }
                } else {
                    context.fill(Path(rect), with: .color(.black.opacity(overlayVisibility ? 1.0 : 0.1)))
                }
            }
        }
    }
}

