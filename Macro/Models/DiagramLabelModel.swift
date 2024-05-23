//
//  DiagramLabelModel.swift
//  Macro
//
//  Created by yatziri on 15/05/24.
//

import Foundation
import SwiftData
import CoreGraphics
import SwiftUI

@Model
class DiagramLabel{
    var text:String = ""
    var originX: CGFloat
    var originY: CGFloat
    var width: CGFloat
    var height: CGFloat
    
    init(text: String, rectangle:CGRect) {
        self.text = text
        self.originY = rectangle.origin.y
        self.width = rectangle.width
        self.height = rectangle.height
        self.originX = rectangle.minX
    }
    func toCGRect() -> CGRect {
        return CGRect(x: CGFloat(originX)+80, y: CGFloat(originY), width: CGFloat(width*1.1), height: CGFloat(height))
    }
}
