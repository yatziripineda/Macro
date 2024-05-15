//
//  DiagramLabelModel.swift
//  Macro
//
//  Created by Vitor Kalil on 14/05/24.
//

import Foundation
import SwiftData

@Model
class DiagramLabel{
    var text:String = ""
    var rectangle:CGRect
    init(text: String, rectangle: CGRect) {
        self.text = text
        self.rectangle = rectangle
    }
}
