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
//
//@Model
//class DiagramLabel: Codable {
//    var text: String
//    let rectangle: CGRect
//    
//    init(text: String, rectangle: CGRect) {
//        self.text = text
//        self.rectangle = rectangle
//    }
//    
//    // Codable implementation
//    enum CodingKeys: String, CodingKey {
//        case text
//        case rectangle
//    }
//    
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        text = try container.decode(String.self, forKey: .text)
//        let rectArray = try container.decode([CGFloat].self, forKey: .rectangle)
//        guard rectArray.count == 4 else {
//            throw DecodingError.dataCorruptedError(forKey: .rectangle, in: container, debugDescription: "Rectangle should have four elements.")
//        }
//        rectangle = CGRect(x: rectArray[0], y: rectArray[1], width: rectArray[2], height: rectArray[3])
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(text, forKey: .text)
//        let rectArray = [rectangle.origin.x, rectangle.origin.y, rectangle.size.width, rectangle.size.height]
//        try container.encode(rectArray, forKey: .rectangle)
//    }
//}
//
//extension CGRect: Codable {
//    public init(from decoder: Decoder) throws {
//        var container = try decoder.unkeyedContainer()
//        let origin = try container.decode(CGPoint.self)
//        let size = try container.decode(CGSize.self)
//        self.init(origin: origin, size: size)
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.unkeyedContainer()
//        try container.encode(origin)
//        try container.encode(size)
//    }
//}




@Model
class DiagramLabel{
    var text:String = ""
    var originX: CGFloat
    var originY: CGFloat
    var width: CGFloat
    var height: CGFloat
    //var origin:CGPoint
    
    init(text: String, rectangle:CGRect) {
        self.text = text
        
        //self.originY = rectangle.minY
        self.originY = rectangle.origin.y
        self.width = rectangle.width
        self.height = rectangle.height
        //self.originX = rectangle.minX
        self.originX = rectangle.minX
        //print(rectangle.origin)
    }
    func toCGRect() -> CGRect {
        return CGRect(x: CGFloat(originX)+80, y: CGFloat(originY), width: CGFloat(width*1.1), height: CGFloat(height))
    }
    
}
//    required convenience init?(coder aDecoder: NSCoder) {
//            let text = aDecoder.decodeObject(forKey: "text") as! String
//            let originX = aDecoder.decodeFloat(forKey: "originX")
//            let originY = aDecoder.decodeFloat(forKey: "originY")
//            let width = aDecoder.decodeFloat(forKey: "width")
//            let height = aDecoder.decodeFloat(forKey: "height")
//            let rectangle = CGRect(x: CGFloat(originX), y: CGFloat(originY), width: CGFloat(width), height: CGFloat(height))
//            self.init(text: text, rectangle: rectangle)
//        }
//
//        func encode(with aCoder: NSCoder) {
//            aCoder.encode(text, forKey: "text")
//            aCoder.encode(Float(rectangle.origin.x), forKey: "originX")
//            aCoder.encode(Float(rectangle.origin.y), forKey: "originY")
//            aCoder.encode(Float(rectangle.size.width), forKey: "width")
//            aCoder.encode(Float(rectangle.size.height), forKey: "height")
//        }
