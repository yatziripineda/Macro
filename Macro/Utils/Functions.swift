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

func iconCatalogFunc() -> [String] {
    return ["figure","globe.americas.fill","tree.fill","brain.filled.head.profile","fossil.shell.fill","map.fill","lungs.fill","mountain.2.fill","allergens.fill","house.fill","atom","pawprint.fill","music.note","soccerball.inverse","sparkles","camera.shutter.button.fill","wrench.adjustable.fill","scissors","cart.fill","applescript.fill","stethoscope","theatermask.and.paintbrush.fill","building.columns.fill","macbook.and.iphone","guitars.fill","car.fill","hanger","ladybug.fill","fish.fill","gamecontroller.fill","carrot.fill","fork.knife","banknote.fill","textformat.alt","function","popcorn.fill"]

}
