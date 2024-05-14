//
//  RectanglesOverlay.swift
//  Macro
//
//  Created by Jose Miguel Torres Chavez Nava on 08/05/24.
//

import SwiftUI

struct RectanglesOverlay: View {
    
    var rectangles: [(String, CGRect)]
    @Binding var currentIndex: Int
    
    var body: some View {
        // We use a canvas to draw 2D graphics inside a SwiftUI view.
        Canvas { context, size in
            // We don't need the String data inside the cycle
            for (index, rect) in rectangles.enumerated() {
                            if index == currentIndex {
                                context.fill(Path(rect.1), with: .color(.red)) // Cambiar el color del rectángulo actual
                            } else {
                                context.fill(Path(rect.1), with: .color(.black.opacity(0.5))) // Usar color por defecto para otros rectángulos
                            }
                        }
        }
    }
}
// Vista previa para la estructura RectanglesOverlay
struct RectanglesOverlay_Preview: PreviewProvider {
    static var previews: some View {
        RectanglesOverlay(rectangles: [("Rectangle 1", CGRect(x: 100, y: 50, width: 200, height: 50)),
                                       ("Rectangle 2", CGRect(x: 50, y: 200, width: 250, height: 50))], currentIndex: .constant(1))
            .frame(width: 300, height: 300)
//
    }
}
