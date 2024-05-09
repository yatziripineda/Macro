//
//  RectanglesOverlay.swift
//  Macro
//
//  Created by Jose Miguel Torres Chavez Nava on 08/05/24.
//

import SwiftUI

struct RectanglesOverlay: View {
    
    var rectangles: [(String, CGRect)]
    
    var body: some View {
        // We use a canvas to draw 2D graphics inside a SwiftUI view.
        Canvas { context, size in
            // We don't need the String data inside the cycle
            for (_, rect) in rectangles {
                context.fill(Path(rect), with: .color(.black.opacity(0.5)))
            }
        }
    }
}
