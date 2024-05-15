//
//  DiagramLabelModel.swift
//  Macro
//
//  Created by yatziri on 15/05/24.
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
