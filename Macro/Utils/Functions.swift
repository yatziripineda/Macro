//
//  Functions.swift
//  Macro
//
//  Created by Jose Miguel Torres Chavez Nava on 23/05/24.
//

import Foundation
import SwiftUI

func tuppleToDiagramLabel(rectangles:[(String,CGRect)]) -> [DiagramLabel]{
    var tupleList:[DiagramLabel] = []
    for (s,r) in rectangles{
        tupleList.append(DiagramLabel(text: s, rectangle: r))
    }
    return tupleList
}
