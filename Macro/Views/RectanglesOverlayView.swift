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
    
    var body: some View {
        // Usamos un canvas para dibujar gráficos 2D dentro de una vista SwiftUI.
        Canvas { context, size in
            for (index, label) in labels.enumerated() {
                let rect = label.toCGRect()
                if index == currentIndex {
                    context.fill(Path(rect), with: .color(.red)) // Cambiar el color del rectángulo actual
                } else {
                    context.fill(Path(rect), with: .color(.black.opacity(0.5))) // Usar color por defecto para otros rectángulos
                }
            }
        }
    }
}
//// Vista previa para la estructura RectanglesOverlay
//struct RectanglesOverlay_Preview: PreviewProvider {
//    static var previews: some View {
//        RectanglesOverlay(rectangles: [("Rectangle 1", CGRect(x: 100, y: 50, width: 200, height: 50)),
//                                       ("Rectangle 2", CGRect(x: 50, y: 200, width: 250, height: 50))], currentIndex: .constant(1))
//            .frame(width: 300, height: 300)
////
//    }
//}
